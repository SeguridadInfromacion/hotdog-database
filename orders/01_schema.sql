-- Base de datos del servicio de ventas.
-- Solo orders-service puede conectarse a esta base (red interna "orders-data").
--
-- No hay llaves foráneas hacia usuarios ni productos: viven en otras bases.
-- Por eso cada venta guarda una copia del nombre y el precio al momento de vender.

CREATE TABLE orders (
    id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cashier_id       uuid        NOT NULL,
    cashier_username varchar(32) NOT NULL,
    customer_name    varchar(60) NOT NULL DEFAULT '',
    total            integer     NOT NULL CHECK (total > 0),
    created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX orders_created_at_idx ON orders (created_at DESC);
CREATE INDEX orders_cashier_idx ON orders (cashier_id);

CREATE TABLE order_items (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id     uuid        NOT NULL REFERENCES orders (id) ON DELETE CASCADE,
    product_id   uuid        NOT NULL,
    product_name varchar(60) NOT NULL,
    unit_price   integer     NOT NULL CHECK (unit_price > 0),
    quantity     integer     NOT NULL CHECK (quantity BETWEEN 1 AND 20),
    line_total   integer     NOT NULL CHECK (line_total = unit_price * quantity)
);

CREATE INDEX order_items_order_idx ON order_items (order_id);
