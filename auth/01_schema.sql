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
    -- Sube al cambiar contraseña o rol y al cerrar sesión: invalida tokens viejos.
    token_version   integer      NOT NULL DEFAULT 0 CHECK (token_version >= 0),
    created_at      timestamptz  NOT NULL DEFAULT now()
);

-- Intentos fallidos por pareja (usuario, IP). Bloquear por pareja impide que un
-- extraño deje por fuera al dueño de la cuenta fallando a propósito.
CREATE TABLE login_throttle (
    username         varchar(32) NOT NULL REFERENCES users (username) ON DELETE CASCADE,
    ip               varchar(45) NOT NULL,
    failed_attempts  integer     NOT NULL DEFAULT 0 CHECK (failed_attempts >= 0),
    first_failure_at timestamptz NOT NULL DEFAULT now(),
    locked_until     timestamptz,
    PRIMARY KEY (username, ip)
);
