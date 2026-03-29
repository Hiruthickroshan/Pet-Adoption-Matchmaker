# Entity-Relationship Diagram

## Overview

The Pet Adoption Matchmaker database follows a straightforward three-entity relational model. The core idea is that a **Pet** and an **Adopter** are independent entities whose attributes are compared by the matchmaking logic, and every scored pairing is recorded in a **Matches** join table.

---

## Entities and Relationships

```
┌─────────────────────────────┐         ┌─────────────────────────────────┐
│            PETS             │         │            ADOPTERS             │
├─────────────────────────────┤         ├─────────────────────────────────┤
│ PK  pet_id       SERIAL     │         │ PK  adopter_id     SERIAL       │
│     name         VARCHAR    │         │     full_name      VARCHAR      │
│     species      VARCHAR    │         │     email          VARCHAR(UNIQ)│
│     breed        VARCHAR    │         │     phone          VARCHAR      │
│     age_years    NUMERIC    │         │     living_space   VARCHAR      │
│     size         VARCHAR    │         │     has_yard       BOOLEAN      │
│     energy_level VARCHAR    │         │     activity_level VARCHAR      │
│     good_with_kids BOOLEAN  │         │     has_children   BOOLEAN      │
│     good_with_pets BOOLEAN  │         │     has_other_pets BOOLEAN      │
│     indoor_friendly BOOLEAN │         │     preferred_species VARCHAR   │
│     description  TEXT       │         │     preferred_size VARCHAR      │
│     status       VARCHAR    │         │     preferred_energy VARCHAR    │
│     created_at   TIMESTAMPTZ│         │     experience_level VARCHAR    │
└──────────────┬──────────────┘         │     created_at     TIMESTAMPTZ │
               │                        └────────────────┬────────────────┘
               │ 1                                      1 │
               │                                          │
               │           ┌───────────────────┐          │
               │           │      MATCHES      │          │
               └──────────►│                   │◄─────────┘
                  1..*     ├───────────────────┤   1..*
                           │ PK match_id SERIAL│
                           │ FK pet_id   INT   │
                           │ FK adopter_id INT │
                           │ compatibility_    │
                           │     score SMALLINT│
                           │ status    VARCHAR │
                           │ matched_at        │
                           │     TIMESTAMPTZ   │
                           │ notes      TEXT   │
                           └───────────────────┘
```

---

## Cardinality

| Relationship           | Description                                                    |
|------------------------|----------------------------------------------------------------|
| Pet → Matches          | One pet can appear in many match records (1 : N)               |
| Adopter → Matches      | One adopter can appear in many match records (1 : N)           |
| Pet + Adopter → Match  | Each (pet, adopter) pair is unique in Matches (unique index)   |

---

## Key Design Decisions

| Decision | Rationale |
|---|---|
| `UNIQUE (pet_id, adopter_id)` in Matches | Prevents duplicate suggestions for the same pair |
| `CHECK` constraints on status/size/energy | Enforces valid domain values without a separate lookup table |
| Compatibility score stored in Matches | Caches computed score; avoids recalculation on every read |
| `CASCADE` deletes | Removing a pet or adopter automatically cleans up orphaned match rows |
| Separate `preferred_*` columns in Adopters | Enables fast index scans during matchmaking without JSON parsing |

---

## Scoring Criteria (Matchmaking Logic)

The `compatibility_score` (0–100) is computed in `queries.sql` using the following weighted criteria:

| Criterion                        | Points |
|----------------------------------|--------|
| Species preference match         |   20   |
| Size preference match            |   20   |
| Energy level match               |   20   |
| Pet safe with children (if req.) |   15   |
| Pet friendly with other animals  |   10   |
| Indoor lifestyle compatibility   |   10   |
| Activity level alignment         |    5   |
| **Total**                        | **100**|
