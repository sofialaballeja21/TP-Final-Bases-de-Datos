CREATE TABLE descuento (
    idDescuentos SERIAL PRIMARY KEY,
    codigo_descuento INTEGER NOT NULL,
    fecha_inicio  DATE,
    fecha_fin  DATE CHECK (fecha_fin < fecha_inicio),
    porcentaje  SERIAL NOT NULL CHECK (porcentaje BETWEEN 0 AND 100)
);
drop table descuento 

CREATE TABLE carrito (
    idCarrito  SERIAL PRIMARY KEY,
    cantidad_producto INTEGER CHECK (cantidad_producto >= 0),
    total real CHECK (total >= 0),
    idDescuentos SERIAL,
    CONSTRAINT fk_Descuento FOREIGN KEY (idDescuentos) REFERENCES descuento(idDescuentos)
);

CREATE TABLE usuario (
    idusuarios SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    correo VARCHAR(254) NOT NULL UNIQUE,
    telefono VARCHAR(15) NOT NULL UNIQUE CHECK (telefono ~ '^[0-9]+$'),
    contrasenia VARCHAR(255) NOT NULL UNIQUE CHECK (LENGTH(contrasenia) >= 8),
    rol BOOLEAN NOT NULL,
    idCarrito SERIAL,
    CONSTRAINT fk_Carrito FOREIGN KEY (idCarrito) REFERENCES carrito(idCarrito)
);

CREATE TABLE peticionProducto (
    idPeticion SERIAL PRIMARY KEY,
    peticion VARCHAR(500) NOT NULL,
    fechaPedido   DATE DEFAULT current_date,  -- La fecha del pedido debe ser menor o iguala la fecha actual
    idusuarios SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios)
);

CREATE TABLE reseniaComentario (
    idReseniaComentario SERIAL PRIMARY KEY,
    comentario VARCHAR(100)  NOT null , --CORREGIR EN DICCIONARIO
    resenia INTEGER NOT NULL CHECK (resenia BETWEEN 1 AND 5),
    idusuarios SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios)
);

CREATE TABLE coleccion (
    idColeccion SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT null UNIQUE
);

CREATE TABLE producto (
    idProducto SERIAL PRIMARY key,
    nombre VARCHAR(255) NOT NULL,
    numero INTEGER NOT NULL,
    nombreEdicion VARCHAR(255) NOT NULL,
    esEspecial BOOLEAN NOT NULL,
    descripcion TEXT NOT NULL,
    brilla BOOLEAN NOT NULL,
    precio REAL NOT null check (precio >= 0) ,
    stock INTEGER NOT NULL check (stock >= 0),
    URL_imagen VARCHAR(500) NOT NULL,
    idColeccion SERIAL,
    CONSTRAINT fk_Coleccion FOREIGN KEY (idColeccion) REFERENCES coleccion(idColeccion)
);

CREATE TABLE preguntas (
    idPregunta SERIAL PRIMARY KEY,
    pregunta VARCHAR(100) NOT NULL,
    respuesta VARCHAR(50) NOT NULL,
    idusuarios SERIAL,
    idProducto SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);


CREATE TABLE promocion (
    idPromocion SERIAL PRIMARY KEY,
    porcentaje SERIAL NOT NULL CHECK (porcentaje BETWEEN 0 AND 100),
    fecha_inicio  DATE,
    fecha_fin  DATE check(fecha_fin > fecha_inicio ),
    idProducto SERIAL,
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);


CREATE TABLE factura (
    idFactura SERIAL PRIMARY KEY,
    pagoTotal REAL NOT null check (pagoTotal > 0),
    formaPago VARCHAR(255) NOT NULL,
    productosComprados TEXT NOT NULL,
    impuestos REAL NOT null ,  --Preguntar si se hace un trigger o se pone el 21% directamente
    idDescuentos SERIAL,
    fechaEmision DATE default current_date, --agregado recien
    CONSTRAINT fk_Descuento FOREIGN KEY (idDescuentos) REFERENCES descuento(idDescuentos)
);


CREATE TABLE lineaFactura (
    idLineaFactura SERIAL PRIMARY KEY,
    precio REAL NOT null check(precio > 0),
    cantidad INTEGER NOT null check (cantidad > 0),
    idFactura SERIAL,
    idProducto SERIAL,
    idDescuentos SERIAL,
    CONSTRAINT fk_Factura FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE productoxCarrito (
    idProductoxCarrito SERIAL PRIMARY KEY,
    cantidad INTEGER NOT null check(cantidad > 0),
    precio REAL NOT null check(precio > 0),
    idProducto SERIAL,
    idCarrito SERIAL,
    CONSTRAINT fk_Carrito FOREIGN KEY (idCarrito) REFERENCES carrito(idCarrito),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);



CREATE TABLE ingresoStock (
    idStock SERIAL PRIMARY KEY,
    cantidadIngresada INTEGER NOT null check (cantidadIngresada > 0),
    idProducto SERIAL,
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);


CREATE TABLE codigoSeguimiento (
    idCodigoSeguimiento SERIAL PRIMARY KEY,
    codigo VARCHAR(10) NOT null UNIQUE,
    idFactura SERIAL,
    CONSTRAINT fk_Factura FOREIGN KEY (idFactura) REFERENCES factura(idFactura)
);
