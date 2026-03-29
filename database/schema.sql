-- ============================================================
--  Pet Adoption Matchmaker — Database Schema
--  Author : Hiruthickroshan E.
--  DBMS   : PostgreSQL 13+
--
--  MySQL 8+ compatibility notes:
--    • Replace SERIAL with INT AUTO_INCREMENT
--    • Replace TIMESTAMPTZ with TIMESTAMP (or DATETIME)
--    • Replace FILTER (WHERE ...) aggregate syntax in queries
--      with SUM(CASE WHEN ... THEN 1 ELSE 0 END)
--    • Replace TRUE/FALSE literals with 1/0 in older versions
-- ============================================================

-- ============================================================
--  Drop existing tables (safe re-run)
-- ============================================================
DROP TABLE IF EXISTS Matches  CASCADE;
DROP TABLE IF EXISTS Adopters CASCADE;
DROP TABLE IF EXISTS Pets     CASCADE;

-- ============================================================
--  ENUM-style CHECK domains
--  (Replace with actual ENUMs if your DBMS supports them)
-- ============================================================

-- ============================================================
--  Table: Pets
--  Stores the profile of every pet available for adoption.
-- ============================================================
CREATE TABLE Pets (
    pet_id          SERIAL          PRIMARY KEY,
    name            VARCHAR(100)    NOT NULL,
    species         VARCHAR(50)     NOT NULL,                  -- Dog | Cat | Rabbit | Bird | Other
    breed           VARCHAR(100),
    age_years       NUMERIC(4, 1)   NOT NULL CHECK (age_years >= 0),
    size            VARCHAR(20)     NOT NULL                   -- Small | Medium | Large
                        CHECK (size IN ('Small', 'Medium', 'Large')),
    energy_level    VARCHAR(20)     NOT NULL                   -- Low | Medium | High
                        CHECK (energy_level IN ('Low', 'Medium', 'High')),
    good_with_kids  BOOLEAN         NOT NULL DEFAULT FALSE,
    good_with_pets  BOOLEAN         NOT NULL DEFAULT FALSE,
    indoor_friendly BOOLEAN         NOT NULL DEFAULT TRUE,
    description     TEXT,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Available'
                        CHECK (status IN ('Available', 'Pending', 'Adopted')),
    created_at      TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ============================================================
--  Table: Adopters
--  Stores adopter contact details and lifestyle preferences.
-- ============================================================
CREATE TABLE Adopters (
    adopter_id        SERIAL          PRIMARY KEY,
    full_name         VARCHAR(150)    NOT NULL,
    email             VARCHAR(200)    NOT NULL UNIQUE,
    phone             VARCHAR(20),
    living_space      VARCHAR(20)     NOT NULL               -- Apartment | House | Farm
                          CHECK (living_space IN ('Apartment', 'House', 'Farm')),
    has_yard          BOOLEAN         NOT NULL DEFAULT FALSE,
    activity_level    VARCHAR(20)     NOT NULL               -- Sedentary | Moderate | Active
                          CHECK (activity_level IN ('Sedentary', 'Moderate', 'Active')),
    has_children      BOOLEAN         NOT NULL DEFAULT FALSE,
    has_other_pets    BOOLEAN         NOT NULL DEFAULT FALSE,
    preferred_species VARCHAR(50),                           -- NULL means no preference
    preferred_size    VARCHAR(20)     NOT NULL DEFAULT 'Any'
                          CHECK (preferred_size IN ('Small', 'Medium', 'Large', 'Any')),
    preferred_energy  VARCHAR(20)     NOT NULL DEFAULT 'Any'
                          CHECK (preferred_energy IN ('Low', 'Medium', 'High', 'Any')),
    experience_level  VARCHAR(20)     NOT NULL DEFAULT 'Novice'
                          CHECK (experience_level IN ('Novice', 'Intermediate', 'Expert')),
    created_at        TIMESTAMPTZ     NOT NULL DEFAULT NOW()
);

-- ============================================================
--  Table: Matches
--  Records scored pairings between pets and adopters.
-- ============================================================
CREATE TABLE Matches (
    match_id             SERIAL          PRIMARY KEY,
    pet_id               INT             NOT NULL
                             REFERENCES Pets(pet_id)     ON DELETE CASCADE,
    adopter_id           INT             NOT NULL
                             REFERENCES Adopters(adopter_id) ON DELETE CASCADE,
    compatibility_score  SMALLINT        NOT NULL
                             CHECK (compatibility_score BETWEEN 0 AND 100),
    status               VARCHAR(20)     NOT NULL DEFAULT 'Suggested'
                             CHECK (status IN ('Suggested', 'Approved', 'Rejected', 'Adopted')),
    matched_at           TIMESTAMPTZ     NOT NULL DEFAULT NOW(),
    notes                TEXT,
    -- Prevent duplicate active suggestions for the same pair
    UNIQUE (pet_id, adopter_id)
);

-- ============================================================
--  Indexes for common query patterns
-- ============================================================
CREATE INDEX idx_pets_status        ON Pets    (status);
CREATE INDEX idx_pets_species       ON Pets    (species);
CREATE INDEX idx_pets_size          ON Pets    (size);
CREATE INDEX idx_pets_energy        ON Pets    (energy_level);

CREATE INDEX idx_adopters_species   ON Adopters (preferred_species);
CREATE INDEX idx_adopters_size      ON Adopters (preferred_size);
CREATE INDEX idx_adopters_energy    ON Adopters (preferred_energy);

CREATE INDEX idx_matches_pet        ON Matches  (pet_id);
CREATE INDEX idx_matches_adopter    ON Matches  (adopter_id);
CREATE INDEX idx_matches_score      ON Matches  (compatibility_score DESC);
CREATE INDEX idx_matches_status     ON Matches  (status);
