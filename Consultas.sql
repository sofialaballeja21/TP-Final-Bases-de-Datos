
--Obtener los productos con stock disponible
select p.idproducto, p.nombre, p.nombreEdicion
from producto p 
where p.stock > 0

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
select u.nombre, c.cantidad_producto, c.total
from usuario u, carrito c

