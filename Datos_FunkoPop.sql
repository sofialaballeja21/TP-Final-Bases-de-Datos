-- 2. Insertar datos en la tabla "descuento"
INSERT INTO descuento (idDescuentos, codigo_descuento, fecha_inicio, fecha_fin, porcentaje) values
(0, 0000, '2025-01-01', '2025,01-02', 00),
(-1, 0001, '2025-01-01', '2025,01-02', 01),
(1, 1001, '2024-01-01', '2025-01-31', 10),
(2, 1002, '2024-02-01', '2025-02-28', 15),
(3, 1003, '2024-03-01', '2025-03-31', 20),
(4, 1004, '2024-04-01', '2025-04-30', 5),
(5, 1005, '2024-05-01', '2025-05-31', 30),
(6, 1006, '2024-06-01', '2025-06-30', 25),
(7, 1007, '2024-07-01', '2025-07-31', 40),
(8, 1008, '2024-08-01', '2025-08-31', 50),
(9, 1009, '2024-09-01', '2025-09-30', 35),
(10,1010, '2024-10-01', '2025-10-31', 45),
(11,1011, '2024-11-01', '2025-11-30', 55),
(12,1012, '2024-12-01', '2025-12-31', 60),
(13,1013, '2025-01-01', '2025-01-31', 70),
(14,1014, '2025-02-01', '2025-02-28', 80),
(15,1015, '2025-03-01', '2025-03-31', 90);

-- 3. Insertar datos en la tabla "carrito"
INSERT INTO carrito (idcarrito, cantidad_producto, total, idDescuentos)
VALUES 
(111, 1, 23.44, 0),
(222, 1, 12.34, -1),
(333, 3, 18.33, 2),
(444, 1, 20.00, 3),
(555, 2, 100.00, 4),
(666, 3, 60.00, 5),
(777, 5, 200.00, 6),
(888, 2, 80.00, 7),
(999, 1, 15.00, 8),
(100, 2, 55.00, 9),
(110, 3, 120.00, 10),
(120, 2, 65.00, 11),
(130, 4, 90.00, 12),
(140, 7, 250.00, 13),
(150, 1, 30.00, 14),
(160, 2, 75.00, 15);

-- 4. Insertar datos en la tabla "usuario"
INSERT INTO usuario (idusuarios, nombre, apellido, direccion, correo, telefono, contraseña, rol, idCarrito)
VALUES 
(1, 'Juan', 'Perez', 'Calle 1', 'juanperez@gmail.com', '1234567890', 'contraseñajuan', TRUE, 111), --ADMINISTRADOR
(2, 'Pablo', 'Gomez', 'Calle 2', 'pablogomez@gmail.com', '2223334444', 'contraseñapablo', TRUE, 222); --ADMINISTRADOR
INSERT INTO usuario (idusuarios, nombre, apellido, direccion, correo, telefono, contraseña, rol, idCarrito)
VALUES 
(3, 'Constanza', 'Lopez', 'Calle 3', 'constanzalopez@gmail.com', '3334445555', 'contraseñaconstanza', FALSE, 333),--CLIENTE
(4, 'Lazaro', 'Alberdi', 'Calle 4', 'lazaroalberdi@hotmail.com', '4445556666', 'contraseñalazaro', FALSE, 444),
(5, 'Romina', 'Castañas', 'Calle 5', 'rominacastañas@hotmail.com', '5556667777', 'contraseñaromina', FALSE, 555),
(6, 'Mariano', 'Garcia', 'Calle 6', 'marianogarzia@hotmail.com', '6667778888', 'contraseñamariano', FALSE, 666),
(7, 'Milagros', 'Dominguez', 'Calle 7', 'milagrosdominguez@gmail.com', '7778889999', 'contraseñamilagros', FALSE, 777),
(8, 'Emma', 'Belice', 'Calle 8', 'emmabelice@gmail.com', '8889990000', 'contraseñaemma', FALSE, 888),
(9, 'Ivan', 'Cazuna', 'Calle 9', 'ivancazuna@hotmail.com', '9990001111', 'contraseñaivan', FALSE, 999),
(10, 'Lucia', 'Fernandez', 'Calle 10', 'luciafernandez@gmail.com', '1112223333', 'contraseñalucia', FALSE, 110),
(11, 'Nancy', 'Armanda', 'Calle 11', 'nancyarmanda@gmail.com', '2223334445', 'contraseñanancy', FALSE, 120),
(12, 'Oscar', 'Bustamante', 'Calle 12', 'oscarbustamante@hotmail.com', '3334445556', 'contraseñaoscar', FALSE, 130),
(13, 'Pamela', 'Cabrera', 'Calle 13', 'pamelacabrera@hotmail.com', '4445556667', 'contraseñapamela', FALSE, 140),
(14, 'Petra', 'Diaz', 'Calle 14', 'petradiaz@gmail.com', '5556667778', 'contraseñapetra', FALSE, 150),
(15, 'Jorge', 'Escalada', 'Calle 15', 'jorgeescalada@hotmail.com', '6667709889', 'contraseñacarlos', FALSE, 160);


--Muestra los roles asignados a cada usuario
SELECT u.usename AS username, r.rolname AS rolename
FROM pg_user u
JOIN pg_auth_members am ON u.usesysid = am.member
JOIN pg_roles r ON am.roleid = r.oid
WHERE u.usename IN ('juanperez@gmail.com', 'pablogomez@gmail.com', 'constanzalopez@gmail.com', 'lazaroalberdi@hotmail.com','rominacastañas@hotmail.com',
 'marianogarzia@hotmail.com', 'milagrosdominguez@gmail.com', 'emmabelice@gmail.com', 'ivancazuna@hotmail.com', 'luciafernandez@gmail.com',
'nancyarmanda@gmail.com', 'oscarbustamante@hotmail.com', 'pamelacabrera@hotmail.com',  'petradiaz@gmail.com', 'petradiaz@gmail.com','jorgeescalada@hotmail.com' );

SELECT idusuarios, nombre, apellido, correo, rol 
FROM usuario 
WHERE correo = 'juanperez@gmail.com';


-- 5. Insertar datos en la tabla peticiónProducto
INSERT INTO peticionProducto (idPeticion, peticion, fechaPedido, idusuarios) VALUES
(1, 'Solicito una figura exclusiva de Spider-Man.', '2024-01-05', 1),
(2, 'Quisiera un Funko de Batman con el traje clásico.', '2024-01-10', 2),
(3, '¿Podrían traer un Funko de Harry Potter con la varita en mano?', '2024-01-15', 3),
(4, 'Me gustaría un Funko de Darth Vader con sable rojo.', '2024-01-20', 4),
(5, '¿Pueden agregar un Funko de Goku Super Saiyajin?', '2024-01-25', 5),
(6, 'Quisiera una figura de Pikachu edición limitada.', '2024-02-01', 6),
(7, 'Me gustaría ver un Funko de Luffy con su sombrero de paja.', '2024-02-10', 7),
(8, '¿Pueden traer una figura de Naruto con el modo sabio?', '2024-02-15', 8),
(9, 'Estoy buscando un Funko de Mickey Mouse edición especial.', '2024-02-20', 9),
(10, '¿Tienen en stock Funkos de Rick y Morty?', '2024-02-25', 10),
(11, 'Me encantaría un Funko de Eleven de Stranger Things.', '2024-03-01', 11),
(12, 'Solicito un Funko de Dwight Schrute con gafas.', '2024-03-05', 12),
(13, '¿Pueden traer un Funko de Jon Snow con Ghost?', '2024-03-10', 13),
(14, 'Estoy buscando una figura de Gandalf con bastón.', '2024-03-15', 14),
(15, 'Quisiera un Funko exclusivo de Freddy Funko.', '2024-03-20', 15);

-- 6. Insertar datos en la tabla "reseñaComentario"
INSERT into reseniaComentario (idReseniaComentario, comentario, resenia, idusuarios) VALUES
(1, 'Excelente calidad del producto.', 5, 1),
(2, 'El embalaje llegó en mal estado.', 2, 2),
(3, 'Figura increíble, los detalles son geniales.', 5, 3),
(4, 'Esperaba un tamaño más grande.', 3, 4),
(5, 'Buen producto, pero tardó en llegar.', 4, 5),
(6, 'La pintura tiene algunos defectos.', 3, 6),
(7, 'Perfecto para mi colección.', 5, 7),
(8, 'No es lo que esperaba, decepcionado.', 2, 8),
(9, 'Muy buena atención al cliente.', 4, 9),
(10, 'El producto es de alta calidad.', 5, 10),
(11, 'El precio es alto para la calidad.', 3, 11),
(12, 'Me encantó, llegó antes de lo esperado.', 5, 12),
(13, 'No tiene la calidad que esperaba.', 3, 13),
(14, 'Buen Funko, pero la caja venía dañada.', 3, 14),
(15, 'Lo mejor que he comprado, recomendado.', 5, 15);

-- 7. Insertar datos en la tabla "coleccion"
INSERT INTO coleccion (idColeccion, nombre) VALUES
(1, 'Marvel'),
(2, 'DC Comics'),
(3, 'Harry Potter'),
(4, 'Star Wars'),
(5, 'Anime'),
(6, 'Disney'),
(7, 'Series de TV'),
(8, 'Películas'),
(9, 'Videojuegos'),
(10, 'Música'),
(11, 'Deportes'),
(12, 'Clásicos'),
(13, 'Colección Exclusiva'),
(14, 'Funko Originals'),
(15, 'Edición Especial');

-- 8. Insertar datos en la tabla "producto"
INSERT INTO producto (idProducto, nombre, numero, nombreEdicion, esEspecial, descripcion, brilla, precio, stock, cantidadDisponible, URL_imagen, idColeccion) VALUES
(1, 'Iron Man', 1, 'Avengers', TRUE, 'Figura de Iron Man con armadura roja y dorada.', FALSE, 25.99, TRUE, 10, 'imagen_ironman.jpg', 1),
(2, 'Batman', 2, 'Dark Knight', FALSE, 'Figura de Batman con su clásico traje negro.', FALSE, 22.50, TRUE, 15, 'imagen_batman.jpg', 2),
(3, 'Harry Potter', 3, 'Hogwarts', TRUE, 'Harry Potter con varita y capa de Hogwarts.', FALSE, 20.00, TRUE, 20, 'imagen_harrypotter.jpg', 3),
(4, 'Darth Vader', 4, 'Star Wars', TRUE, 'Figura de Darth Vader con sable de luz.', TRUE, 30.00, TRUE, 8, 'imagen_vader.jpg', 4),
(5, 'Goku', 5, 'Dragon Ball Z', TRUE, 'Goku en modo Super Saiyajin.', TRUE, 28.00, TRUE, 12, 'imagen_goku.jpg', 5),
(6, 'Mickey Mouse', 6, 'Disney Classics', FALSE, 'Figura clásica de Mickey Mouse.', FALSE, 18.99, TRUE, 25, 'imagen_mickey.jpg', 6),
(7, 'Luffy', 7, 'One Piece', TRUE, 'Figura de Luffy con su sombrero de paja.', FALSE, 27.50, TRUE, 10, 'imagen_luffy.jpg', 5),
(8, 'Naruto', 8, 'Naruto Shippuden', TRUE, 'Naruto con el modo sabio activado.', FALSE, 26.00, TRUE, 15, 'imagen_naruto.jpg', 5),
(9, 'Rick Sanchez', 9, 'Rick and Morty', FALSE, 'Figura de Rick con su pistola de portales.', FALSE, 22.00, TRUE, 18, 'imagen_rick.jpg', 7),
(10, 'Jon Snow', 10, 'Game of Thrones', TRUE, 'Jon Snow con su espada Garra.', FALSE, 24.50, TRUE, 10, 'imagen_jonsnow.jpg', 8),
(11, 'Freddy Mercury', 11, 'Queen', TRUE, 'Figura de Freddy Mercury en concierto.', FALSE, 29.00, TRUE, 12, 'imagen_freddy.jpg', 10),
(12, 'Cristiano Ronaldo', 12, 'Football Legends', FALSE, 'Figura de CR7 en uniforme de Portugal.', FALSE, 32.00, TRUE, 8, 'imagen_cr7.jpg', 11),
(13, 'Pac-Man', 13, 'Videojuegos Clásicos', FALSE, 'Figura de Pac-Man en 8 bits.', FALSE, 19.50, TRUE, 20, 'imagen_pacman.jpg', 9),
(14, 'Gandalf', 14, 'El Señor de los Anillos', TRUE, 'Figura de Gandalf con su bastón.', FALSE, 27.00, TRUE, 10, 'imagen_gandalf.jpg', 12),
(15, 'Funko Original', 15, 'Exclusive', TRUE, 'Funko original con diseño exclusivo.', FALSE, 35.00, TRUE, 5, 'imagen_funkooriginal.jpg', 14);

-- 9. Insertar datos en la tabla "preguntas"
INSERT INTO preguntas (idPregunta, pregunta, respuesta, idusuarios, idProducto) VALUES
(1, '¿Es original?', 'Sí, todos nuestros productos son originales.', 1, 1),
(2, '¿Cuánto mide la figura?', 'Mide aproximadamente 10 cm.', 2, 2),
(3, '¿Viene con caja?', 'Sí, se envía con su caja original.', 3, 3),
(4, '¿Hacen envíos a todo el país?', 'Sí, realizamos envíos nacionales.', 4, 4),
(5, '¿Se puede pagar en cuotas?', 'Sí, aceptamos pagos en cuotas.', 5, 5),
(6, '¿Es edición limitada?', 'Sí, es una edición especial.', 6, 6),
(7, '¿Cuánto tarda el envío?', 'Depende de la ubicación, entre 3 y 7 días.', 7, 7),
(8, '¿Puedo comprar más de uno?', 'Sí, sin límite de compra.', 8, 8),
(9, '¿Tienen garantía?', 'Sí, garantía de 30 días.', 9, 9),
(10, '¿Se puede personalizar?', 'No, los diseños son estándar.', 10, 10),
(11, '¿Hacen envíos internacionales?', 'No, realizamos envíos a todo el mundo.', 11, 11),
(12, '¿Cuánto cuesta el envío?', 'El costo de envío es de $5.00.', 12, 12),
(13, '¿Se puede devolver?', 'Sí, se aceptan devoluciones.', 13, 13),
(14, '¿Cuánto tiempo tengo para devolver?', 'Tienes 15 días para devolverlo.', 14, 14),
(15, '¿Se puede retirar en tienda?', 'Sí, puedes retirar en nuestra tienda.', 15, 15);

-- 10. Insertar datos en la tabla "promocion"
INSERT INTO promocion (idPromocion, porcentaje, fecha_inicio, fecha_fin, idProducto) VALUES
(1, 10, '2024-02-01', '2024-02-15', 1),
(2, 15, '2024-02-10', '2024-02-20', 2),
(3, 20, '2024-03-01', '2024-03-15', 3),
(4, 25, '2024-03-10', '2024-03-25', 4),
(5, 30, '2024-04-01', '2024-04-15', 5),
(6, 35, '2024-04-10', '2024-04-20', 6),
(7, 40, '2024-05-01', '2024-05-15', 7),
(8, 50, '2024-05-10', '2024-05-20', 8),
(9, 35, '2024-06-01', '2024-06-15', 9),
(10, 45, '2024-06-10', '2024-06-20', 10),
(11, 55, '2024-07-01', '2024-07-15', 11),
(12, 60, '2024-07-10', '2024-07-20', 12),
(13, 70, '2024-08-01', '2024-08-15', 13),
(14, 80, '2024-08-10', '2024-08-20', 14),
(15, 90, '2024-09-01', '2024-09-15', 15);


-- 11. Insertar datos en la tabla "factura"
INSERT INTO factura (idFactura, pagoTotal, formaPago, productosComprados, impuestos, idDescuentos) VALUES
(1, 50.00, 'Mercado Pago', 'Iron Man, Batman', 21.00, 1),
(2, 35.50, 'Mercado Pago', 'Harry Potter', 21.00, 2),
(3, 60.00, 'Mercado Pago', 'Darth Vader, Goku', 21.00, 3),
(4, 22.00, 'Mercado Pago', 'Mickey Mouse', 21.00, 4),
(5, 45.00, 'Mercado Pago', 'Luffy, Naruto', 21.00, 5),
(6, 70.00, 'Mercado Pago', 'Rick Sanchez, Jon Snow', 21.00, 6),
(7, 25.00, 'Mercado Pago', 'Freddy Mercury', 21.00, 7),
(8, 30.00, 'Mercado Pago', 'Cristiano Ronaldo', 21.00, 8),
(9, 40.00, 'Mercado Pago', 'Naruto', 21.00, 9),
(10, 55.00, 'Mercado Pago', 'One Pice', 21.00, 10),
(11, 65.00, 'Mercado Pago', 'Freddy Mercury', 21.00, 11),
(12, 75.00, 'Mercado Pago', 'Cristiano Ronaldo', 21.00, 12),
(13, 80.00, 'Mercado Pago', 'Pac Man', 21.00, 13),
(14, 90.00, 'Mercado Pago', 'Gandalf', 21.00, 14),
(15, 100.00, 'Mercado Pago', 'Funko Original', 21.00, 15);

-- 12. Insertar datos en la tabla "lineaFactura"
INSERT INTO lineaFactura (idLineaFactura, precio, cantidad, idFactura, idProducto, idDescuentos) VALUES
(1, 25.99, 1, 1, 1, 1),
(2, 22.50, 1, 1, 2, NULL),
(3, 20.00, 1, 2, 3, 2),
(4, 30.00, 1, 3, 4, NULL),
(5, 28.00, 1, 3, 5, 3),
(6, 18.99, 2, 4, 6, NULL),
(7, 27.50, 1, 5, 7, 5),
(8, 26.00, 1, 5, 8, NULL),
(9, 22.00, 2, 6, 9, 6),
(10, 24.50, 1, 7, 10, NULL),
(11, 29.00, 1, 8, 11, 7),
(12, 32.00, 1, 9, 12, 8),
(13, 19.50, 3, 10, 13, NULL),
(14, 27.00, 1, 11, 14, 9),
(15, 35.00, 1, 12, 15, NULL);

-- 13. Insertar datos en la tabla "productoxCarrito"
INSERT INTO productoxCarrito (idProductoxCarrito, cantidad, precio, idProducto, idCarrito) VALUES
(1, 1, 25.99, 1, 111),
(2, 2, 22.50, 2, 222),
(3, 1, 20.00, 3, 333),
(4, 1, 30.00, 4, 444),
(5, 1, 28.00, 5, 555),
(6, 3, 18.99, 6, 666),
(7, 2, 27.50, 7, 777),
(8, 1, 26.00, 8, 888),
(9, 2, 22.00, 9, 999),
(10, 1, 24.50, 10, 110),
(11, 1, 29.00, 11, 120),
(12, 1, 32.00, 12, 130),
(13, 4, 19.50, 13, 140),
(14, 1, 27.00, 14, 150),
(15, 1, 35.00, 15, 160);

-- 14. Insertar datos en la tabla "ingresoStock"
INSERT INTO ingresoStock (idStock, cantidadIngresada, idProducto) VALUES
(1, 10, 1),
(2, 15, 2),
(3, 20, 3),
(4, 8, 4),
(5, 12, 5),
(6, 25, 6),
(7, 10, 7),
(8, 15, 8),
(9, 18, 9),
(10, 10, 10),
(11, 12, 11),
(12, 8, 12),
(13, 20, 13),
(14, 10, 14),
(15, 5, 15);

-- 15. Insertar datos en la tabla "codigoSeguimiento"
INSERT INTO codigoSeguimiento (idCodigoSeguimiento, codigo, idFactura) VALUES
(1, 'ABC123XYZ', 1),
(2, 'DEF456UVW', 2),
(3, 'GHI789RST', 3),
(4, 'JKL012MNO', 4),
(5, 'PQR345STU', 5),
(6, 'VWX678YZA', 6),
(7, 'BCD901EFG', 7),
(8, 'HIJ234KLM', 8),
(9, 'NOP567QRS', 9),
(10, 'TUV890WXY', 10),
(11, 'ZAB123CDE', 11),
(12, 'FGH456IJK', 12),
(13, 'LMN789OPQ', 13),
(14, 'RST012UVW', 14),
(15, 'XYZ345ABC', 15);


SET session_replication_role = replica;
TRUNCATE TABLE  usuario  CASCADE;

SET session_replication_role = DEFAULT;

