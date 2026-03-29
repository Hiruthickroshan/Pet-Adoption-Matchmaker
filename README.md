# 🐾 Pet Adoption Matchmaker

[![Live Demo](https://img.shields.io/badge/Live%20Demo-GitHub%20Pages-6366f1?style=for-the-badge&logo=github)](https://hiruthickroshan.github.io/Pet-Adoption-Matchmaker/)

A robust SQL-based backend system designed to intelligently pair pets with adopters based on lifestyle compatibility, pet characteristics, and adopter preferences. The matchmaking engine uses structured queries to score and rank pet–adopter pairings so every animal finds the right home.

> **🚀 Try the [Live Interactive Demo](https://hiruthickroshan.github.io/Pet-Adoption-Matchmaker/)** — the full database runs entirely in your browser via SQLite (sql.js). Browse pets, explore adopter profiles, run the matchmaking engine, and execute custom SQL queries — no installation required.

---

## 📋 Table of Contents

- [Features](#features)
- [Live Demo](#-live-demo)
- [Project Structure](#project-structure)
- [Tech Stack](#tech-stack)
- [Database Schema](#database-schema)
- [Getting Started](#-getting-started)
- [Example Queries](#-example-queries)
- [Author](#-author)

---

## ✨ Features

- **Pet Profiles** – Store detailed records for each pet including species, breed, age, size, energy level, and temperament.
- **Adopter Preferences** – Capture adopter lifestyle data such as living space, activity level, experience with animals, and preferred characteristics.
- **Compatibility Scoring** – Automated matchmaking logic computes a compatibility score for every pet–adopter pair using multi-criteria filtering.
- **Match Records** – Dedicated `Matches` table tracks every match, its score, status, and timestamps.
- **Seed Data** – Ready-to-use sample data for immediate testing and demonstration.

---

## 📁 Project Structure

```
Pet-Adoption-Matchmaker/
├── README.md                  # Project overview and documentation
├── database/
│   ├── schema.sql             # DDL: table definitions and constraints
│   ├── queries.sql            # Matchmaking and reporting queries
│   └── seed_data.sql          # Sample pets, adopters, and matches
└── docs/
    └── ER_diagram.md          # Entity-relationship diagram (text)
```

---

## 🛠 Tech Stack

| Layer        | Technology                  |
|--------------|-----------------------------|
| Database     | SQL (PostgreSQL / MySQL)    |
| Query Engine | Standard SQL + Window funcs |
| Schema Design| Relational / 3NF            |

---

## 🗄 Database Schema

### `Pets`
Stores the profile of every pet available for adoption.

| Column          | Type         | Description                              |
|-----------------|--------------|------------------------------------------|
| pet_id          | SERIAL PK    | Unique pet identifier                    |
| name            | VARCHAR(100) | Pet's name                               |
| species         | VARCHAR(50)  | e.g. Dog, Cat, Rabbit                    |
| breed           | VARCHAR(100) | Specific breed                           |
| age_years       | NUMERIC(4,1) | Age in years                             |
| size            | VARCHAR(20)  | Small / Medium / Large                   |
| energy_level    | VARCHAR(20)  | Low / Medium / High                      |
| good_with_kids  | BOOLEAN      | Safe around children                     |
| good_with_pets  | BOOLEAN      | Gets along with other animals            |
| indoor_friendly | BOOLEAN      | Suitable for indoor living               |
| description     | TEXT         | Free-text notes                          |
| status          | VARCHAR(20)  | Available / Adopted / Pending            |
| created_at      | TIMESTAMPTZ  | Record creation timestamp                |

### `Adopters`
Stores adopter profile and lifestyle preferences.

| Column               | Type         | Description                              |
|----------------------|--------------|------------------------------------------|
| adopter_id           | SERIAL PK    | Unique adopter identifier                |
| full_name            | VARCHAR(150) | Adopter's full name                      |
| email                | VARCHAR(200) | Contact email (unique)                   |
| phone                | VARCHAR(20)  | Contact phone                            |
| living_space         | VARCHAR(20)  | Apartment / House / Farm                 |
| has_yard             | BOOLEAN      | Access to outdoor yard                   |
| activity_level       | VARCHAR(20)  | Sedentary / Moderate / Active            |
| has_children         | BOOLEAN      | Children present in household            |
| has_other_pets       | BOOLEAN      | Other animals in household               |
| preferred_species    | VARCHAR(50)  | Preferred type of pet                    |
| preferred_size       | VARCHAR(20)  | Small / Medium / Large / Any             |
| preferred_energy     | VARCHAR(20)  | Low / Medium / High / Any                |
| experience_level     | VARCHAR(20)  | Novice / Intermediate / Expert           |
| created_at           | TIMESTAMPTZ  | Record creation timestamp                |

### `Matches`
Records scored pairings between pets and adopters.

| Column              | Type        | Description                              |
|---------------------|-------------|------------------------------------------|
| match_id            | SERIAL PK   | Unique match identifier                  |
| pet_id              | INT FK      | References `Pets(pet_id)`                |
| adopter_id          | INT FK      | References `Adopters(adopter_id)`        |
| compatibility_score | SMALLINT    | Score 0–100 (higher = better match)      |
| status              | VARCHAR(20) | Suggested / Approved / Rejected / Adopted|
| matched_at          | TIMESTAMPTZ | When the match was created               |
| notes               | TEXT        | Reviewer or system notes                 |

---

## 🌐 Live Demo

The project includes an interactive browser demo deployed on GitHub Pages:

**URL:** [https://hiruthickroshan.github.io/Pet-Adoption-Matchmaker/](https://hiruthickroshan.github.io/Pet-Adoption-Matchmaker/)

| Tab | What you can do |
|-----|----------------|
| 📊 Dashboard | Live stats — available pets, active matches, best score, species breakdown |
| 🐾 Pets | Filterable pet gallery (by species & status) |
| 👥 Adopters | Full adopter profiles and preferences |
| 🤝 Matchmaker | Pick any adopter → see top-5 compatible pets with score bars + 7-criterion breakdown |
| 💻 SQL Explorer | Run all 8 pre-built queries or write custom SQL against the live in-browser database |

### Enabling GitHub Pages

1. Go to **Settings → Pages** in the repository.
2. Under *Source*, select **Deploy from a branch**.
3. Choose **main** branch and **/ (root)** folder.
4. Save — the site will be live at the URL above within a minute.

---

## 🚀 Getting Started

### Prerequisites

- PostgreSQL 13+ **or** MySQL 8+ installed and running.

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/Hiruthickroshan/Pet-Adoption-Matchmaker.git
cd Pet-Adoption-Matchmaker

# 2. Create the database  (PostgreSQL example)
psql -U postgres -c "CREATE DATABASE pet_adoption;"

# 3. Apply the schema
psql -U postgres -d pet_adoption -f database/schema.sql

# 4. Load sample data
psql -U postgres -d pet_adoption -f database/seed_data.sql

# 5. Run example queries
psql -U postgres -d pet_adoption -f database/queries.sql
```

For **MySQL**, replace `psql` commands with:
```bash
mysql -u root -p pet_adoption < database/schema.sql
```

---

## 🔍 Example Queries

See [`database/queries.sql`](database/queries.sql) for the full set. Key queries include:

- **Top matches for a specific adopter** – ranks all available pets by compatibility score.
- **Best adopters for a specific pet** – finds the most suitable adopter candidates.
- **Full match report** – joins pets, adopters, and matches with detailed scoring breakdown.
- **Availability summary** – aggregates pet counts by species and status.

---

## 👤 Author

**Hiruthickroshan E.**

- GitHub: [@Hiruthickroshan](https://github.com/Hiruthickroshan)

---

## 📄 License

This project is open-source and available under the [MIT License](LICENSE).
