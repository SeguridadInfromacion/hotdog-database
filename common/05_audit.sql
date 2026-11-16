-- Bitácora de auditoría. Cada servicio tiene la suya en su propia base.
-- El rol de la aplicación solo puede INSERTAR y LEER (ver 90_roles.sh):
-- ni la propia aplicación puede borrar o alterar el rastro.

CREATE TABLE audit_log (
    id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    occurred_at timestamptz  NOT NULL DEFAULT now(),
    actor       varchar(32)  NOT NULL,
    action      varchar(48)  NOT NULL,
    target      varchar(120) NOT NULL DEFAULT '',
    ip          varchar(45)  NOT NULL DEFAULT ''
);

CREATE INDEX audit_log_occurred_at_idx ON audit_log (occurred_at DESC);
