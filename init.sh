#!/bin/bash
set -e

# Export database connection details
export PGPASSWORD="${DB_PASSWORD}"

# Create Odoo role if it doesn't exist
psql -h "${DB_HOST}" -p "${DB_PORT}" -U "${DB_USER}" -v ON_ERROR_STOP=1 <<-EOSQL
    DO \$\$
    BEGIN
        IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = '$DB_ODOO_USER') THEN
            CREATE ROLE $DB_ODOO_USER WITH LOGIN PASSWORD '$DB_ODOO_PASSWORD';
        END IF;
        ALTER ROLE $DB_ODOO_USER CREATEDB NOCREATEROLE NOREPLICATION;
    END
    \$\$;
EOSQL
