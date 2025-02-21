--Lista los productos en stock, con sus atributos. Administrador y clientes
-- Obtener los productos con stock disponible
SELECT idProducto, nombre, precio, stock
FROM Producto
WHERE stock TRUE;

--Lista de usuarios que han dado reseñas malas 

SELECT u.nombre, c.comentario, c.resenia
FROM usuario u
JOIN reseniaComentario c ON u.idusuarios = c.idReseniaComentario
WHERE c.resenia <= 3;

--Lista de productos agrupados por colección.
SELECT p.nombre, p.nombreEdicion, p.descripcion, p.precio, c.nombre
FROM producto p
JOIN coleccion c ON p.idproducto  = c.idcoleccion 


--Lista de los usuarios y su carrito

SELECT u.idusuarios, u.nombre, u.direccion, c.cantidad_producto
FROM usuario u
JOIN carrito c ON u.idusuarios = c.idCarrito
