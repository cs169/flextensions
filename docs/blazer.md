---
title: blazer
published: false
---

# Setting Up Admin Query Tools

* Manually make people an admin
* Setup SQL

```sql
BEGIN;
CREATE ROLE blazer LOGIN PASSWORD 'secret';
GRANT CONNECT ON DATABASE flextensions_development TO blazer;
GRANT USAGE ON SCHEMA public TO blazer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
COMMIT;

CREATE SCHEMA hypershield;

GRANT USAGE ON SCHEMA hypershield TO blazer;

-- replace migrations with the user who manages your schema
ALTER DEFAULT PRIVILEGES FOR ROLE michael IN SCHEMA hypershield
    GRANT SELECT ON TABLES TO blazer;

-- keep public in search path for functions
ALTER ROLE blazer SET search_path TO hypershield, public;
```

### Configuration (Dev)

```
BLAZER_DATABASE_URL=postgres://blazer:secret@localhost:5432/flextensions_development
```
