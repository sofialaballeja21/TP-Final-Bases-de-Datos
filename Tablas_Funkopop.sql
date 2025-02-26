--Creacion de tablas
CREATE TABLE descuento (
    idDescuentos SERIAL PRIMARY KEY,
    codigo_descuento INTEGER NOT NULL,
    fecha_inicio  DATE DEFAULT CURRENT_DATE,
    fecha_fin  DATE DEFAULT CURRENT_DATE,
    porcentaje  SERIAL NOT NULL CHECK (porcentaje BETWEEN 0 AND 100)
);

CREATE TABLE carrito (
    idCarrito  SERIAL PRIMARY KEY,
    cantidad_producto INTEGER,
    total REAL,
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
    contrasenia VARCHAR(255) NOT NULL CHECK (LENGTH(contrasenia) >= 8),
    rol BOOLEAN NOT NULL,
    idCarrito SERIAL,
    CONSTRAINT fk_Carrito FOREIGN KEY (idCarrito) REFERENCES carrito(idCarrito)
);

CREATE TABLE peticionProducto (
    idPeticion SERIAL PRIMARY KEY,
    peticion VARCHAR(500) NOT NULL,
    fechaPedido  DATE DEFAULT CURRENT_DATE,  
    idusuarios SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios)
);

ALTER TABLE peticionproducto
ADD COLUMN idProducto INT,
ADD CONSTRAINT fk_producto FOREIGN KEY (idProducto) REFERENCES producto(idproducto);


CREATE TABLE reseniaComentario (
    idReseniaComentario SERIAL PRIMARY KEY,
    comentario TEXT NOT NULL,
    resenia INTEGER NOT NULL CHECK (resenia BETWEEN 1 AND 5),
    idusuarios SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios)
);


CREATE TABLE coleccion (
    idColeccion SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

CREATE TABLE producto (
    idProducto SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    numero INTEGER NOT NULL,
    nombreEdicion VARCHAR(255) NOT NULL,
    esEspecial BOOLEAN NOT NULL,
    descripcion TEXT NOT NULL,
    brilla BOOLEAN NOT NULL,
    precio REAL NOT NULL,
    stock BOOLEAN DEFAULT TRUE,
    cantidadDisponible SERIAL NOT NULL,
    URL_imagen VARCHAR(500) NOT NULL,
    idColeccion SERIAL,
    CONSTRAINT fk_Coleccion FOREIGN KEY (idColeccion) REFERENCES coleccion(idColeccion)
);

CREATE TABLE preguntas (
    idPregunta SERIAL PRIMARY KEY,
    pregunta TEXT NOT NULL,
    respuesta TEXT NOT NULL,
    idusuarios SERIAL,
    idProducto SERIAL, 
    CONSTRAINT fk_Usuario FOREIGN KEY (idusuarios) REFERENCES usuario(idusuarios),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE promocion (
    idPromocion SERIAL PRIMARY KEY,
    porcentaje SERIAL NOT NULL CHECK (porcentaje BETWEEN 0 AND 100),
    fecha_inicio  DATE DEFAULT CURRENT_DATE,
    fecha_fin  DATE DEFAULT CURRENT_DATE,
    idProducto SERIAL,
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE factura (
    idFactura SERIAL PRIMARY KEY,
    pagoTotal REAL NOT NULL,
    formaPago VARCHAR(255) NOT NULL,
    productosComprados TEXT NOT NULL,
    impuestos REAL NOT NULL,
    idDescuentos SERIAL,
    CONSTRAINT fk_Descuento FOREIGN KEY (idDescuentos) REFERENCES descuento(idDescuentos)
);

CREATE TABLE lineaFactura (
    idLineaFactura SERIAL PRIMARY KEY,
    precio REAL NOT NULL,
    cantidad INTEGER NOT NULL,
    idFactura SERIAL,
    idProducto SERIAL,
    idDescuentos SERIAL,
    CONSTRAINT fk_Factura FOREIGN KEY (idFactura) REFERENCES factura(idFactura),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE productoxCarrito (
    idProductoxCarrito SERIAL PRIMARY KEY,
    cantidad INTEGER NOT NULL,
    precio REAL NOT NULL,
    idProducto SERIAL,
    idCarrito SERIAL,
    CONSTRAINT fk_Carrito FOREIGN KEY (idCarrito) REFERENCES carrito(idCarrito),
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE ingresoStock (
    idStock SERIAL PRIMARY KEY,
    cantidadIngresada INTEGER NOT NULL,
    idProducto SERIAL,
    CONSTRAINT fk_Producto FOREIGN KEY (idProducto) REFERENCES producto(idProducto)
);

CREATE TABLE codigoSeguimiento (
    idCodigoSeguimiento SERIAL PRIMARY KEY,
    codigo VARCHAR(255) NOT NULL,
    idFactura SERIAL,
    CONSTRAINT fk_Factura FOREIGN KEY (idFactura) REFERENCES factura(idFactura)
);

