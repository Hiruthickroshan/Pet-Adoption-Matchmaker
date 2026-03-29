-- ============================================================
--  Pet Adoption Matchmaker — Sample / Seed Data
--  Author : Hiruthickroshan E.
--  Run AFTER schema.sql
-- ============================================================

-- ============================================================
--  Pets (15 sample records)
-- ============================================================
INSERT INTO Pets (name, species, breed, age_years, size, energy_level,
                  good_with_kids, good_with_pets, indoor_friendly, description, status)
VALUES
    ('Buddy',    'Dog',    'Golden Retriever',  3.0,  'Large',  'High',
     TRUE,  TRUE,  FALSE, 'Loves outdoor runs and playing fetch.',            'Available'),

    ('Milo',     'Dog',    'Beagle',            2.5,  'Medium', 'Medium',
     TRUE,  TRUE,  TRUE,  'Friendly and curious, great family dog.',          'Available'),

    ('Bella',    'Cat',    'Persian',           4.0,  'Small',  'Low',
     FALSE, FALSE, TRUE,  'Calm and independent, perfect for quiet homes.',   'Available'),

    ('Max',      'Dog',    'Border Collie',     1.5,  'Medium', 'High',
     TRUE,  FALSE, FALSE, 'Highly intelligent, needs lots of mental stimulation.','Available'),

    ('Luna',     'Cat',    'Siamese',           2.0,  'Small',  'Medium',
     TRUE,  TRUE,  TRUE,  'Social and vocal, loves human interaction.',       'Available'),

    ('Rocky',    'Dog',    'Bulldog',           5.0,  'Medium', 'Low',
     TRUE,  TRUE,  TRUE,  'Laid-back couch companion.',                       'Available'),

    ('Cleo',     'Rabbit', 'Holland Lop',       1.0,  'Small',  'Low',
     TRUE,  FALSE, TRUE,  'Gentle and quiet, ideal for small apartments.',    'Available'),

    ('Charlie',  'Dog',    'Labrador Retriever',4.0,  'Large',  'High',
     TRUE,  TRUE,  FALSE, 'Energetic and loyal, loves swimming.',             'Available'),

    ('Daisy',    'Cat',    'Maine Coon',        3.5,  'Medium', 'Low',
     TRUE,  TRUE,  TRUE,  'Friendly giant, great with children.',             'Available'),

    ('Oliver',   'Bird',   'African Grey',      6.0,  'Small',  'Low',
     FALSE, FALSE, TRUE,  'Highly intelligent, requires attentive owner.',    'Available'),

    ('Nala',     'Dog',    'Shih Tzu',          2.0,  'Small',  'Low',
     TRUE,  TRUE,  TRUE,  'Affectionate lap dog, great for seniors.',         'Available'),

    ('Leo',      'Cat',    'Bengal',            1.5,  'Medium', 'High',
     FALSE, FALSE, TRUE,  'Active and playful, needs enrichment toys.',       'Available'),

    ('Sophie',   'Dog',    'German Shepherd',   3.0,  'Large',  'Medium',
     TRUE,  FALSE, FALSE, 'Loyal protector, responds well to training.',      'Available'),

    ('Ginger',   'Rabbit', 'Rex',               2.0,  'Small',  'Medium',
     TRUE,  FALSE, TRUE,  'Curious and social, enjoys gentle handling.',      'Available'),

    ('Simba',    'Cat',    'Scottish Fold',     4.0,  'Small',  'Low',
     TRUE,  TRUE,  TRUE,  'Quiet and loving, perfect indoor companion.',      'Adopted');

-- ============================================================
--  Adopters (10 sample records)
-- ============================================================
INSERT INTO Adopters (full_name, email, phone, living_space, has_yard,
                      activity_level, has_children, has_other_pets,
                      preferred_species, preferred_size, preferred_energy, experience_level)
VALUES
    ('Arun Kumar',     'arun.kumar@email.com',    '9876543210', 'House',     TRUE,
     'Active',    TRUE,  FALSE, 'Dog',    'Large',  'High',   'Intermediate'),

    ('Priya Sharma',   'priya.sharma@email.com',  '9876543211', 'Apartment', FALSE,
     'Sedentary', FALSE, TRUE,  'Cat',    'Small',  'Low',    'Novice'),

    ('Ravi Patel',     'ravi.patel@email.com',    '9876543212', 'House',     TRUE,
     'Moderate',  TRUE,  TRUE,  'Dog',    'Medium', 'Medium', 'Expert'),

    ('Meena Nair',     'meena.nair@email.com',    '9876543213', 'Apartment', FALSE,
     'Sedentary', FALSE, FALSE, 'Cat',    'Small',  'Low',    'Novice'),

    ('Karthik Reddy',  'karthik.r@email.com',     '9876543214', 'Farm',      TRUE,
     'Active',    TRUE,  TRUE,  'Dog',    'Large',  'High',   'Expert'),

    ('Divya Iyer',     'divya.iyer@email.com',    '9876543215', 'Apartment', FALSE,
     'Moderate',  TRUE,  FALSE, 'Rabbit', 'Small',  'Low',    'Novice'),

    ('Suresh Menon',   'suresh.menon@email.com',  '9876543216', 'House',     TRUE,
     'Moderate',  FALSE, TRUE,  'Dog',    'Medium', 'Low',    'Intermediate'),

    ('Lakshmi Devi',   'lakshmi.d@email.com',     '9876543217', 'House',     FALSE,
     'Sedentary', FALSE, TRUE,  'Cat',    'Medium', 'Low',    'Novice'),

    ('Vijay Bose',     'vijay.bose@email.com',    '9876543218', 'Apartment', FALSE,
     'Active',    FALSE, FALSE, 'Bird',   'Small',  'Low',    'Expert'),

    ('Ananya Singh',   'ananya.s@email.com',      '9876543219', 'House',     TRUE,
     'Moderate',  TRUE,  FALSE, 'Dog',    'Any',    'Any',    'Intermediate');

-- ============================================================
--  Pre-computed Matches (sample high-confidence pairings)
--  Scores below were derived by manually applying the seven-
--  criterion weighted formula documented in queries.sql:
--    Species(20) + Size(20) + Energy(20) + Kids(15)
--    + OtherPets(10) + Indoor(10) + Activity(5) = 100 max
-- ============================================================
INSERT INTO Matches (pet_id, adopter_id, compatibility_score, status, notes)
VALUES
    -- Buddy (Large/High/Dog) → Arun Kumar (Active, House+Yard, Large/High/Dog)
    (1,  1,  95, 'Approved',  'Excellent lifestyle match — outdoor space and energy align.'),
    -- Bella (Small/Low/Cat)  → Priya Sharma (Sedentary, Apartment, Small/Low/Cat)
    (3,  2,  92, 'Approved',  'Quiet apartment environment suits Bella perfectly.'),
    -- Rocky (Medium/Low/Dog) → Suresh Menon (Moderate, House+Yard, Medium/Low)
    (6,  7,  88, 'Suggested', 'Temperament and energy level are a strong match.'),
    -- Cleo (Small/Low/Rabbit)→ Divya Iyer (Moderate, Apartment, Small/Low/Rabbit)
    (7,  6,  85, 'Suggested', 'Indoor rabbit matches apartment lifestyle well.'),
    -- Oliver (Small/Low/Bird)→ Vijay Bose (Active, Apartment, Small/Low/Bird, Expert)
    (10, 9,  90, 'Approved',  'Expert level owner well-suited for intelligent parrot.'),
    -- Charlie (Large/High)   → Karthik Reddy (Active, Farm, Large/High, Expert)
    (8,  5,  97, 'Adopted',   'Perfect farm and activity match — adoption completed.'),
    -- Daisy (Medium/Low/Cat) → Lakshmi Devi (Sedentary, House, Medium/Low/Cat)
    (9,  8,  83, 'Suggested', 'Calm cat suits quiet household.'),
    -- Milo (Medium/Medium/Dog)→ Ravi Patel (Moderate, House+Yard, Medium/Medium)
    (2,  3,  89, 'Approved',  'Family home with yard is ideal for Milo.');
