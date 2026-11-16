-- Menú inicial para que la demo no arranque vacía.

INSERT INTO products (name, description, price) VALUES
    ('Perro Sencillo',    'Salchicha, papita triturada y salsas de la casa.',            8000),
    ('Perro Especial',    'Salchicha, queso derretido, tocineta y papita triturada.',   12000),
    ('Perro Hawaiano',    'Salchicha, piña en almíbar, queso y salsa rosada.',          14000),
    ('Perro Ranchero',    'Salchicha ranchera, chorizo, maíz tierno y queso costeño.',  15000),
    ('Perro Vegetariano', 'Salchicha de lentejas, guacamole, pico de gallo y queso.',   13000),
    ('Súper Perro',       'Doble salchicha, huevo de codorniz, tocineta y todo lo demás.', 18000)
ON CONFLICT (name) DO NOTHING;
