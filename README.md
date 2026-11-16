# hotdog-database

Esquemas, datos iniciales y permisos de las tres bases de datos de
**PerroCaliente Express**. Cada servicio tiene su propia base PostgreSQL; ninguna
se comparte.

Documentación general: [hotdog-docs](https://github.com/SeguridadInfromacion/hotdog-docs).

## Estructura

| Ruta | Base | Contenido |
|---|---|---|
| `auth/01_schema.sql` | `auth` | Tablas `users` y `login_throttle` |
| `products/01_schema.sql` | `products` | Tabla `products` |
| `products/10_seed.sql` | `products` | Menú inicial |
| `orders/01_schema.sql` | `orders` | Tablas `orders` y `order_items` |
| `common/05_audit.sql` | las tres | Tabla `audit_log` |
| `common/20_role.sh` | las tres | Crea el rol de aplicación, sin permisos sobre las tablas |
| `*/30_grants.sql` | cada una | Los permisos exactos que usa ese servicio |

`hotdog-infra` monta estos archivos en `/docker-entrypoint-initdb.d/` de cada
contenedor de PostgreSQL. Se ejecutan en orden alfabético, **solo la primera
vez** que se crea el volumen de datos.

## Decisiones de seguridad

- **Mínimo privilegio.** La aplicación no se conecta como superusuario. Su rol
  no puede crear, alterar ni borrar tablas, y sobre cada tabla tiene solo lo que
  usa: `orders_app` inserta y lee ventas pero no puede editarlas ni borrarlas;
  `auth_app` no puede borrar usuarios. Los nombres de los roles (`auth_app`,
  `products_app`, `orders_app`) deben coincidir con `APP_DB_USER` en `hotdog-infra`.
- **Topes por rol.** Máximo 20 conexiones y 5 segundos por consulta.
- **Auditoría de solo-agregar.** En `audit_log` el rol de la aplicación solo
  puede `INSERT` y `SELECT`. Ni la propia aplicación puede borrar su rastro.
- **Restricciones en la base.** Los `CHECK` (precio positivo, rol válido,
  `line_total = unit_price * quantity`) son la última línea de defensa si la
  validación de la aplicación fallara.
- **Sin contraseñas.** Solo se guarda el hash Argon2id.
- **Sin llaves foráneas entre bases.** Cada venta guarda copia del nombre y
  precio del producto: los servicios no dependen de la base de otro.
- **Sin secretos en el repositorio.** Las contraseñas de los roles llegan por
  variables de entorno al crear la base.

## Cambiar el esquema

Como los scripts corren solo al crear el volumen, para aplicar un cambio en un
entorno de desarrollo hay que recrear las bases:

```bash
cd ../hotdog-infra
docker compose down -v && docker compose up -d
```

En un sistema en producción se usaría una herramienta de migraciones (por
ejemplo Alembic) en lugar de borrar los datos.
