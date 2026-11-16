-- Mínimo privilegio para orders-service (rol orders_app, definido en hotdog-infra).

-- Una venta registrada no se edita ni se borra: solo se agrega y se consulta.
GRANT SELECT, INSERT ON orders, order_items TO orders_app;

-- La bitácora es de solo-agregar: ni la propia aplicación puede alterarla.
GRANT SELECT, INSERT ON audit_log TO orders_app;
