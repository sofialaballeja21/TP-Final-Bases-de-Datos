CREATE VIEW productos_disponibles AS
SELECT 
    p.idproducto,
    p.nombre AS producto_nombre,
    p.precio,
    p.stock
FROM Producto p
WHERE p.stock = TRUE;

CREATE VIEW productos_por_coleccion AS
SELECT 
    c.nombre AS coleccion_nombre,
    p.nombre AS producto_nombre,
    p.precio
FROM Producto p
JOIN Coleccion c ON p.idcoleccion = c.idcoleccion;


CREATE VIEW clientes_registrados AS
SELECT 
    u.idusuarios,
    u.nombre AS cliente_nombre,
    u.correo
FROM usuario u
WHERE u.rol = TRUE;

