-- Mínimo privilegio para auth-service (rol auth_app, definido en hotdog-infra).

-- Los usuarios se crean y se editan, pero nunca se borran: se desactivan.
GRANT SELECT, INSERT, UPDATE ON users TO auth_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON login_throttle TO auth_app;

-- La bitácora es de solo-agregar: ni la propia aplicación puede alterarla.
GRANT SELECT, INSERT ON audit_log TO auth_app;
