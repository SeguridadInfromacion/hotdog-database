-- Base de datos del servicio de autenticación.
-- Solo auth-service puede conectarse a esta base (red interna "auth-data").

CREATE TABLE users (
    id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    username        varchar(32)  NOT NULL UNIQUE
                    CHECK (username ~ '^[a-z0-9_.-]{3,32}$'),
    full_name       varchar(80)  NOT NULL CHECK (length(trim(full_name)) >= 2),
    -- Nunca se guarda la contraseña: solo su hash Argon2id.
    password_hash   varchar(255) NOT NULL,
    role            varchar(16)  NOT NULL CHECK (role IN ('admin', 'cashier')),
    is_active       boolean      NOT NULL DEFAULT true,
    failed_attempts integer      NOT NULL DEFAULT 0 CHECK (failed_attempts >= 0),
    locked_until    timestamptz,
    created_at      timestamptz  NOT NULL DEFAULT now()
);
