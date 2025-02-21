CREATE OR REPLACE PROCEDURE calcular_ventas_con_descuento(
    p_idUsuario INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_idAdmin INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_es_admin BOOLEAN;
    v_usuario_existente BOOLEAN;
    v_total_descuento REAL;
BEGIN
    -- Verificar si el usuario que ejecuta la acción es un Administrador
    SELECT rol INTO v_es_admin FROM usuario WHERE idusuarios = p_idAdmin;
    
    IF NOT v_es_admin THEN
        RAISE EXCEPTION 'Acceso denegado: Solo los administradores pueden calcular ventas con descuento.';
    END IF;

    -- Verificar si el usuario existe
    SELECT EXISTS(SELECT 1 FROM usuario WHERE idusuarios = p_idUsuario) INTO v_usuario_existente;
    
    IF NOT v_usuario_existente THEN
        RAISE EXCEPTION 'Error: El usuario con ID % no existe.', p_idUsuario;
    END IF;

    -- Calcular el total de ventas con descuento en el rango de fechas
    SELECT COALESCE(SUM(total - (total * COALESCE(descuento, 0) / 100)), 0) 
    INTO v_total_descuento
    FROM venta
    WHERE fecha::DATE BETWEEN p_fecha_inicio AND p_fecha_fin
    AND descuento > 0;  -- Solo considerar ventas con descuento

    -- Mostrar el total de ventas con descuento en el período especificado
    RAISE NOTICE 'El total de ventas con descuento entre % y % es: %', p_fecha_inicio, p_fecha_fin, v_total_descuento;
END;
$$;


--Llamada al procedimiento
--CALL calcular_ventas_con_descuento(1, '2024-01-01', '2024-02-01', 10);

CREATE OR REPLACE PROCEDURE actualizar_stock(
    p_idProducto INT,
    p_cantidadVendida INT,
    p_idUsuario INT -- ID del usuario que ejecuta la acción
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock_actual INT;
    v_es_admin BOOLEAN;
BEGIN
    -- Verificar si el usuario tiene permiso de Administrador
    SELECT rol INTO v_es_admin FROM usuario WHERE idusuarios = p_idAdmin;
    
    IF NOT v_es_admin THEN
        RAISE EXCEPTION 'Acceso denegado: Solo los administradores pueden actualizar el stock.';
    END IF;

    -- Obtener el stock actual del producto
    SELECT stock INTO v_stock_actual FROM producto WHERE idproducto = p_idProducto;
    
    -- Verificar si el producto existe
    IF v_stock_actual IS NULL THEN
        RAISE EXCEPTION 'Error: El producto con ID % no existe.', p_idProducto;
    END IF;

    -- Verificar si hay suficiente stock disponible
    IF v_stock_actual < p_cantidadVendida THEN
        RAISE EXCEPTION 'Error: Stock insuficiente. Stock actual: %, cantidad requerida: %', v_stock_actual, p_cantidadVendida;
    END IF;

    -- Actualizar el stock restando la cantidad vendida
    UPDATE producto
    SET stock = stock - p_cantidadVendida
    WHERE idproducto = p_idProducto;

    RAISE NOTICE 'Stock actualizado correctamente. Nuevo stock: %', v_stock_actual - p_cantidadVendida;
END;
$$;

CALL actualizar_stock(5, 3, 10);


CREATE OR REPLACE PROCEDURE calcular_total_producto(
    p_idProducto INT,
    p_cantidadProductos INT,
    p_idAdmin INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_es_admin BOOLEAN;
    v_precio_unitario REAL;
    v_total REAL;
BEGIN
    -- Verificar si el usuario que ejecuta la acción es un Administrador
    SELECT rol INTO v_es_admin FROM usuario WHERE idusuarios = p_idAdmin;
    
    IF NOT v_es_admin THEN
        RAISE EXCEPTION 'Acceso denegado: Solo los administradores pueden calcular el total de un producto.';
    END IF;

    -- Verificar que la cantidad ingresada sea válida
    IF p_cantidadProductos <= 0 THEN
        RAISE EXCEPTION 'Error: La cantidad de productos debe ser mayor a 0.';
    END IF;

    -- Obtener el precio del producto
    SELECT precio INTO v_precio_unitario FROM producto WHERE idproducto = p_idProducto;

    -- Verificar si el producto existe
    IF v_precio_unitario IS NULL THEN
        RAISE EXCEPTION 'Error: El producto con ID % no existe.', p_idProducto;
    END IF;

    -- Calcular el total
    v_total := v_precio_unitario * p_cantidadProductos;

    -- Mostrar el resultado
    RAISE NOTICE 'El total por % unidades del producto ID % es: %', p_cantidadProductos, p_idProducto, v_total;
END;
$$;

CALL calcular_total_producto(1, 5, 10);
