---------------------------------------------------------------------Descuento
CREATE OR REPLACE FUNCTION validar_porcentaje_y_fechas()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el porcentaje esté entre 0 y 100
    IF NEW.porcentaje < 0 OR NEW.porcentaje > 100 THEN
        RAISE EXCEPTION 'El porcentaje debe estar entre 0 y 100. Valor recibido: %', NEW.porcentaje;
    END IF;

    -- Validar que la fecha de fin sea posterior o igual a la fecha de inicio
    IF NEW.fecha_fin < NEW.fecha_inicio THEN
        RAISE EXCEPTION 'La fecha de fin (%s) debe ser posterior o igual a la fecha de inicio (%s)', NEW.fecha_fin, NEW.fecha_inicio;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para la tabla descuento
CREATE TRIGGER trigger_validar_descuento
BEFORE INSERT OR UPDATE ON descuento
FOR EACH ROW
EXECUTE FUNCTION validar_porcentaje_y_fechas();

--DROP TRIGGER trigger_validar_descuento ON descuento;


-- Crear el trigger para la tabla promocion
CREATE TRIGGER trigger_validar_promocion
BEFORE INSERT OR UPDATE ON promocion
FOR EACH ROW
EXECUTE FUNCTION validar_porcentaje_y_fechas();

---------------------------------------------------------------------Carrito

CREATE OR REPLACE FUNCTION validar_carrito()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la cantidad de productos en el carrito sea mayor que 0
    IF NEW.cantidad_producto <= 0 THEN
        RAISE EXCEPTION 'La cantidad de producto debe ser mayor que 0. Valor recibido: %', NEW.cantidad_producto;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_carrito
BEFORE INSERT OR UPDATE ON carrito
FOR EACH ROW
EXECUTE FUNCTION validar_carrito();

---------------------------------------------------------------------------Usuario
-- Trigger para validar el correo antes de insertar
CREATE OR REPLACE FUNCTION validate_email_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM Usuario WHERE correo = NEW.correo) THEN
        RAISE EXCEPTION 'El correo ya existe.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_usuario
BEFORE INSERT ON Usuario
FOR EACH ROW
EXECUTE FUNCTION validate_email_trigger();

-- Trigger para registrar cambios de contraseña
CREATE OR REPLACE FUNCTION password_log_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO password_auditoria (idusuario, fecha_cambio)
    VALUES (OLD.idusuario, NOW());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_password_log
AFTER UPDATE OF contraseña ON Usuario
FOR EACH ROW
WHEN (OLD.contraseña IS DISTINCT FROM NEW.contraseña)
EXECUTE FUNCTION password_log_trigger();
                                                         

CREATE OR REPLACE FUNCTION delete_usuario(p_idusuario INTEGER) --es una funcion 
RETURNS TEXT AS $$
DECLARE
    usuario_existente RECORD;
BEGIN
    -- Verificar si el usuario existe
    SELECT * INTO usuario_existente
    FROM Usuario
    WHERE idusuario = p_idusuario;

    IF usuario_existente IS NULL THEN
        RETURN 'El usuario no existe.';
    END IF;

    -- Eliminar el usuario
    DELETE FROM Usuario
    WHERE idusuario = p_idusuario;

    RETURN 'Usuario eliminado correctamente.';
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------------PeticionProducto 
CREATE OR REPLACE FUNCTION validar_peticion()

RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la fechaPedido no sea una fecha futura
    IF NEW.fechaPedido > CURRENT_DATE THEN
        RAISE EXCEPTION 'La fecha del pedido no puede ser una fecha futura.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_peticion
BEFORE INSERT OR UPDATE ON peticionProducto
FOR EACH ROW
EXECUTE FUNCTION validar_peticion();


---------------------------------------------------------------------------------------- reseniaComentario
CREATE OR REPLACE FUNCTION validar_resenia_comentario()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la reseña esté entre 1 y 5
    IF NEW.resenia < 1 OR NEW.resenia > 5 THEN
        RAISE EXCEPTION 'La reseña debe estar entre 1 y 5. Valor recibido: %', NEW.resenia;
    END IF;

    -- Validar que el comentario no sea NULL o vacío si existe una reseña
    IF NEW.resenia IS NOT NULL AND (NEW.comentario IS NULL OR LENGTH(TRIM(NEW.comentario)) = 0) THEN
        RAISE EXCEPTION 'El comentario no puede estar vacío si existe una reseña.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_resenia_comentario
BEFORE INSERT OR UPDATE ON ReseniaComentario
FOR EACH ROW
EXECUTE FUNCTION validar_resenia_comentario();

---------------------------------------------------------------------Coleccion
CREATE OR REPLACE FUNCTION validar_coleccion()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el nombre de la colección no esté vacío
    IF NEW.nombre IS NULL OR LENGTH(TRIM(NEW.nombre)) = 0 THEN
        RAISE EXCEPTION 'El nombre de la colección no puede estar vacío.';
    END IF;

    -- Validar que el nombre de la colección no sea duplicado
    IF EXISTS (SELECT 1 FROM coleccion WHERE nombre = NEW.nombre AND idColeccion <> NEW.idColeccion) THEN
        RAISE EXCEPTION 'El nombre de la colección "%" ya existe.', NEW.nombre;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_coleccion
BEFORE INSERT OR UPDATE ON coleccion
FOR EACH ROW
EXECUTE FUNCTION validar_coleccion();

---------------------------------------------------------------------Productos
-- Crear la función para validar e insertar productos
CREATE OR REPLACE FUNCTION validar_producto()
RETURNS TRIGGER AS $$
DECLARE 
    producto_existente RECORD;
BEGIN
    -- Buscar si el producto ya existe
    SELECT * INTO producto_existente FROM producto WHERE idProducto = NEW.idProducto;

    -- Si el producto ya existe, autocompleta los datos con los existentes
    IF FOUND THEN
        NEW.nombre := producto_existente.nombre;
        NEW.numero := producto_existente.numero;
        NEW.nombreEdicion := producto_existente.nombreEdicion;
        NEW.esEspecial := producto_existente.esEspecial;
        NEW.descripcion := producto_existente.descripcion;
        NEW.brilla := producto_existente.brilla;
        NEW.precio := producto_existente.precio;
        NEW.stock := producto_existente.stock;
        NEW.cantidadDisponible := producto_existente.cantidadDisponible;
        NEW.URL_Imagen := producto_existente.URL_Imagen;

        RAISE NOTICE 'El producto con idProducto % ya existe, autocompletando datos', NEW.idProducto;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para ejecutar la función antes de INSERT
CREATE TRIGGER trigger_validar_producto
BEFORE INSERT ON producto
FOR EACH ROW
EXECUTE FUNCTION validar_producto();


-- Crear la función para eliminar un producto por idProducto
CREATE OR REPLACE FUNCTION eliminar_producto()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si el producto existe antes de eliminarlo
    IF NOT EXISTS (SELECT 1 FROM producto WHERE idProducto = OLD.idProducto) THEN
        RAISE EXCEPTION 'El producto con idProducto % no existe', OLD.idProducto;
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para eliminar productos por idProducto
CREATE TRIGGER trigger_eliminar_producto
BEFORE DELETE ON producto
FOR EACH ROW
EXECUTE FUNCTION eliminar_producto();


---------------------------------------------------------------------Preguntas
CREATE OR REPLACE FUNCTION validar_pregunta_respuesta()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el campo pregunta no esté vacío ni exceda 500 caracteres
    IF NEW.pregunta IS NULL OR LENGTH(TRIM(NEW.pregunta)) = 0 THEN
        RAISE EXCEPTION 'El campo "pregunta" no puede estar vacío.';
    ELSIF LENGTH(NEW.pregunta) > 500 THEN
        RAISE EXCEPTION 'El campo "pregunta" no puede exceder los 500 caracteres.';
    END IF;

    -- Validar que el campo respuesta no esté vacío ni exceda 500 caracteres
    IF NEW.respuesta IS NULL OR LENGTH(TRIM(NEW.respuesta)) = 0 THEN
        RAISE EXCEPTION 'El campo "respuesta" no puede estar vacío.';
    ELSIF LENGTH(NEW.respuesta) > 500 THEN
        RAISE EXCEPTION 'El campo "respuesta" no puede exceder los 500 caracteres.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_pregunta_respuesta
BEFORE INSERT OR UPDATE ON preguntas
FOR EACH ROW
EXECUTE FUNCTION validar_pregunta_respuesta();



--------------------------------------------------------------------Factura
CREATE OR REPLACE FUNCTION validar_factura()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que PagoTotal sea mayor que cero
    IF NEW.PagoTotal <= 0 THEN
        RAISE EXCEPTION 'El pago total debe ser mayor a cero. Valor recibido: %', NEW.PagoTotal;
    END IF;

    -- Validar que FormaPago sea válida
    IF NEW.FormaPago NOT IN ('Mercado Pago', 'Transferencia') THEN
        RAISE EXCEPTION 'La forma de pago no es válida. Valor recibido: %', NEW.FormaPago;
    END IF;

    -- Validar que ProductosComprados no sea nulo
    IF NEW.ProductosComprados IS NULL OR LENGTH(NEW.ProductosComprados) = 0 THEN
        RAISE EXCEPTION 'El campo ProductosComprados no puede estar vacío.';
    END IF;

    -- Calcular impuestos automáticamente si no se proporciona
    IF NEW.impuestos IS NULL THEN
        NEW.impuestos := NEW.PagoTotal * 0.21; -- Ejemplo: Impuesto del 21%
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_factura
BEFORE INSERT OR UPDATE ON Factura
FOR EACH ROW
EXECUTE FUNCTION validar_factura();

--------------------------------------------------------------LineaFactura
CREATE OR REPLACE FUNCTION validar_cantidad_precio()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad debe ser mayor que 0';
    END IF;

    IF NEW.precio <= 0 THEN
        RAISE EXCEPTION 'El precio debe ser mayor que 0';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_validar_linea_factura
BEFORE INSERT OR UPDATE ON lineaFactura
FOR EACH ROW
EXECUTE FUNCTION validar_cantidad_precio();

--------------------------------------------------------------ProductoxCarrito
CREATE TRIGGER trigger_validar_productoxCarrito
BEFORE INSERT OR UPDATE ON productoxCarrito
FOR EACH ROW
EXECUTE FUNCTION validar_cantidad_precio();

--------------------------------------------------------------IngresoStock
CREATE OR REPLACE FUNCTION validar_cantidad()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la cantidad ingresada sea mayor que 0
    IF NEW.cantidadIngresada <= 0 THEN
        RAISE EXCEPTION 'La cantidad ingresada debe ser mayor que 0';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Aplicar el trigger a la tabla ingresoStock
CREATE TRIGGER trigger_validar_ingreso_stock
BEFORE INSERT OR UPDATE ON ingresoStock
FOR EACH ROW
EXECUTE FUNCTION validar_cantidad();


-------------------------------------------------------------CodigoSeguimientos
-- Crear función para generar código aleatorio
CREATE OR REPLACE FUNCTION generar_codigo_seguimiento()
RETURNS TRIGGER AS $$
DECLARE
    nuevo_codigo VARCHAR(50);
BEGIN
    -- Generar código aleatorio hasta que sea único
    LOOP
        nuevo_codigo := substr(md5(random()::text), 1, 12); -- 12 caracteres aleatorios
        EXIT WHEN NOT EXISTS (SELECT 1 FROM codigoSeguimiento WHERE codigo = nuevo_codigo);
    END LOOP;

    -- Asignar el código generado a la fila nueva
    NEW.codigo := nuevo_codigo;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trigger_generar_codigo_seguimiento
BEFORE INSERT ON codigoSeguimiento
FOR EACH ROW
EXECUTE FUNCTION generar_codigo_seguimiento();

SELECT trigger_name 
FROM information_schema.triggers 
WHERE event_object_table = 'lineaFactura';
