-- Mínimo privilegio para products-service (rol products_app, definido en hotdog-infra).

-- El menú es un CRUD completo.
GRANT SELECT, INSERT, UPDATE, DELETE ON products TO products_app;

-- La bitácora es de solo-agregar: ni la propia aplicación puede alterarla.
GRANT SELECT, INSERT ON audit_log TO products_app;
