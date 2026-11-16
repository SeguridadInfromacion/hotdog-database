-- Base de datos del servicio de productos (el menú).
-- Solo products-service puede conectarse a esta base (red interna "products-data").

CREATE TABLE products (
    id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    name         varchar(60)  NOT NULL UNIQUE CHECK (length(trim(name)) >= 2),
    description  varchar(200) NOT NULL DEFAULT '',
    -- Precio en pesos colombianos, sin decimales.
    price        integer      NOT NULL CHECK (price BETWEEN 100 AND 1000000),
    is_available boolean      NOT NULL DEFAULT true,
    created_at   timestamptz  NOT NULL DEFAULT now(),
    updated_at   timestamptz  NOT NULL DEFAULT now()
);
