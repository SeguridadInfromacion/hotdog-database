#!/bin/sh
# Crea el rol con el que se conecta la aplicación. Nace SIN permisos sobre las
# tablas: cada base le concede solo lo que usa en su archivo 30_grants.sql.
# El superusuario de PostgreSQL nunca sale del contenedor de la base.
set -eu

: "${APP_DB_USER:?Falta APP_DB_USER}"
: "${APP_DB_PASSWORD:?Falta APP_DB_PASSWORD}"

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -v app_user="$APP_DB_USER" -v app_password="$APP_DB_PASSWORD" \
     -v db_name="$POSTGRES_DB" <<'EOSQL'
CREATE ROLE :"app_user" LOGIN PASSWORD :'app_password'
    NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION
    CONNECTION LIMIT 20;

-- Ninguna consulta de la aplicación puede quedarse colgada acaparando la base.
ALTER ROLE :"app_user" SET statement_timeout = '5s';

-- Nadie entra a ninguna base ni crea objetos "por defecto".
REVOKE ALL ON DATABASE :"db_name" FROM PUBLIC;
REVOKE CONNECT ON DATABASE postgres, template1 FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

GRANT CONNECT ON DATABASE :"db_name" TO :"app_user";
GRANT USAGE ON SCHEMA public TO :"app_user";
EOSQL
