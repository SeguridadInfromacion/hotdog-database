#!/bin/sh
# Crea el rol con el que se conecta la aplicación, con el mínimo privilegio:
#   - puede leer y escribir filas en las tablas de SU base,
#   - no puede crear, alterar ni borrar tablas,
#   - en la bitácora de auditoría solo puede insertar y leer.
# El superusuario de PostgreSQL nunca sale del contenedor de la base.
set -eu

: "${APP_DB_USER:?Falta APP_DB_USER}"
: "${APP_DB_PASSWORD:?Falta APP_DB_PASSWORD}"

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" \
     -v app_user="$APP_DB_USER" -v app_password="$APP_DB_PASSWORD" \
     -v db_name="$POSTGRES_DB" <<'EOSQL'
CREATE ROLE :"app_user" LOGIN PASSWORD :'app_password'
    NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION;

REVOKE ALL ON DATABASE :"db_name" FROM PUBLIC;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;

GRANT CONNECT ON DATABASE :"db_name" TO :"app_user";
GRANT USAGE ON SCHEMA public TO :"app_user";
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO :"app_user";

-- La bitácora es de solo-agregar para la aplicación.
REVOKE UPDATE, DELETE ON audit_log FROM :"app_user";
EOSQL
