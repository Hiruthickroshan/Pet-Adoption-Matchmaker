-- ============================================================
--  Pet Adoption Matchmaker — Matchmaking & Reporting Queries
--  Author : Hiruthickroshan E.
--  Run AFTER schema.sql and seed_data.sql
-- ============================================================

-- ============================================================
--  SCORING VIEW — pet_adopter_scores
--  Centralises the seven-criterion compatibility formula so
--  that all queries below reference a single definition.
--  Any change to the scoring weights only needs to be made here.
--
--  Scoring breakdown (total = 100 pts):
--    Species preference match       20 pts
--    Size preference match          20 pts
--    Energy level match             20 pts
--    Kids safety (if needed)        15 pts
--    Other-pet friendliness         10 pts
--    Indoor lifestyle match         10 pts
--    Activity level alignment        5 pts
-- ============================================================
DROP VIEW IF EXISTS pet_adopter_scores;

CREATE VIEW pet_adopter_scores AS
SELECT
    p.pet_id,
    p.name                                                  AS pet_name,
    p.species,
    p.breed,
    p.age_years,
    p.size,
    p.energy_level,
    p.good_with_kids,
    p.good_with_pets,
    p.indoor_friendly,
    p.status                                                AS pet_status,
    a.adopter_id,
    a.full_name                                             AS adopter_name,
    a.email,
    a.living_space,
    a.activity_level,
    a.experience_level,
    -- ── Species match (20 pts) ──────────────────────────────
    (CASE WHEN a.preferred_species IS NULL
               OR LOWER(a.preferred_species) = LOWER(p.species)     THEN 20 ELSE 0 END
    -- ── Size match (20 pts) ─────────────────────────────────
    + CASE WHEN a.preferred_size = 'Any'
               OR a.preferred_size = p.size                          THEN 20 ELSE 0 END
    -- ── Energy match (20 pts) ───────────────────────────────
    + CASE WHEN a.preferred_energy = 'Any'
               OR a.preferred_energy = p.energy_level                THEN 20 ELSE 0 END
    -- ── Kids safety (15 pts) ────────────────────────────────
    + CASE WHEN NOT a.has_children                                   THEN 15
           WHEN a.has_children AND p.good_with_kids                  THEN 15
           ELSE 0 END
    -- ── Other-pet friendliness (10 pts) ─────────────────────
    + CASE WHEN NOT a.has_other_pets                                 THEN 10
           WHEN a.has_other_pets AND p.good_with_pets                THEN 10
           ELSE 0 END
    -- ── Indoor lifestyle (10 pts) ───────────────────────────
    + CASE WHEN a.living_space = 'Apartment' AND p.indoor_friendly   THEN 10
           WHEN a.living_space IN ('House', 'Farm')                  THEN 10
           ELSE 0 END
    -- ── Activity alignment (5 pts) ──────────────────────────
    + CASE WHEN a.activity_level = 'Active'    AND p.energy_level = 'High'   THEN 5
           WHEN a.activity_level = 'Moderate'  AND p.energy_level = 'Medium' THEN 5
           WHEN a.activity_level = 'Sedentary' AND p.energy_level = 'Low'    THEN 5
           ELSE 0 END
    )                                                       AS compatibility_score
FROM  Pets     p
JOIN  Adopters a ON TRUE;   -- all (pet, adopter) combinations


-- ============================================================
--  QUERY 1 — ALL SCORES FOR AVAILABLE PETS
--  Full cross-product of available pets vs. all adopters,
--  ordered per adopter from best to worst match.
-- ============================================================
SELECT
    pet_id,
    pet_name,
    species,
    breed,
    size,
    energy_level,
    adopter_id,
    adopter_name,
    compatibility_score
FROM  pet_adopter_scores
WHERE pet_status = 'Available'
ORDER BY adopter_id, compatibility_score DESC;


-- ============================================================
--  QUERY 2 — TOP 5 PETS FOR A SPECIFIC ADOPTER
--  Replace the literal adopter_id value to parameterise.
-- ============================================================
SELECT
    pet_id,
    pet_name,
    species,
    breed,
    age_years,
    size,
    energy_level,
    compatibility_score
FROM  pet_adopter_scores
WHERE pet_status  = 'Available'
  AND adopter_id  = 1          -- ← change to target adopter
ORDER BY compatibility_score DESC
LIMIT 5;


-- ============================================================
--  QUERY 3 — BEST ADOPTERS FOR A SPECIFIC PET
--  Replace the literal pet_id value to parameterise.
-- ============================================================
SELECT
    adopter_id,
    adopter_name,
    email,
    living_space,
    activity_level,
    experience_level,
    compatibility_score
FROM  pet_adopter_scores
WHERE pet_id = 1               -- ← change to target pet
ORDER BY compatibility_score DESC
LIMIT 5;


-- ============================================================
--  QUERY 4 — FULL MATCH REPORT
--  Joins Matches with Pets and Adopters for a complete view.
-- ============================================================
SELECT
    m.match_id,
    p.name                  AS pet_name,
    p.species,
    p.breed,
    p.age_years,
    p.size,
    p.energy_level,
    a.full_name             AS adopter_name,
    a.email,
    a.living_space,
    a.activity_level,
    m.compatibility_score,
    m.status                AS match_status,
    m.matched_at,
    m.notes
FROM  Matches  m
JOIN  Pets     p ON p.pet_id     = m.pet_id
JOIN  Adopters a ON a.adopter_id = m.adopter_id
ORDER BY m.compatibility_score DESC;


-- ============================================================
--  QUERY 5 — PETS WITH NO MATCH YET (unmatched pets)
-- ============================================================
SELECT
    p.pet_id,
    p.name,
    p.species,
    p.breed,
    p.status,
    p.created_at
FROM  Pets p
WHERE p.status = 'Available'
  AND NOT EXISTS (
      SELECT 1
      FROM   Matches m
      WHERE  m.pet_id = p.pet_id
  )
ORDER BY p.created_at;


-- ============================================================
--  QUERY 6 — AVAILABILITY SUMMARY BY SPECIES
-- ============================================================
SELECT
    species,
    COUNT(*)                                        AS total_pets,
    COUNT(*) FILTER (WHERE status = 'Available')    AS available,
    COUNT(*) FILTER (WHERE status = 'Pending')      AS pending,
    COUNT(*) FILTER (WHERE status = 'Adopted')      AS adopted
FROM  Pets
GROUP BY species
ORDER BY total_pets DESC;


-- ============================================================
--  QUERY 7 — TOP-RANKED MATCH PER ADOPTER (window function)
--  Uses the pet_adopter_scores view and ROW_NUMBER() to show
--  each adopter's single best available pet.
-- ============================================================
SELECT
    adopter_id,
    adopter_name,
    pet_id,
    pet_name,
    species,
    breed,
    compatibility_score
FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY adopter_id
            ORDER BY compatibility_score DESC
        ) AS rnk
    FROM  pet_adopter_scores
    WHERE pet_status = 'Available'
) ranked
WHERE rnk = 1
ORDER BY compatibility_score DESC;


-- ============================================================
--  QUERY 8 — HIGH-SCORING SUGGESTIONS NOT YET ACTED UPON
--  Surface matches with score >= 80 still in 'Suggested' state.
-- ============================================================
SELECT
    m.match_id,
    p.name           AS pet_name,
    p.species,
    a.full_name      AS adopter_name,
    a.email,
    m.compatibility_score,
    m.matched_at
FROM  Matches  m
JOIN  Pets     p ON p.pet_id     = m.pet_id
JOIN  Adopters a ON a.adopter_id = m.adopter_id
WHERE m.status             = 'Suggested'
  AND m.compatibility_score >= 80
ORDER BY m.compatibility_score DESC;

