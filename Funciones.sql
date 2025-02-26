CREATE OR REPLACE PROCEDURE calcular_cantidad_de_peticiones_de_producto(
    p_idUsuario INT,   -- Usuario que ejecuta la acción
    p_idProducto INT   -- Producto del que se contarán las peticiones
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_es_admin BOOLEAN;
    v_cantidad_peticiones INT;
BEGIN
    -- 🔹 Verificar si el usuario que ejecuta la acción es Administrador
    SELECT rol INTO v_es_admin FROM usuario WHERE idusuarios = p_idUsuario;

    IF NOT v_es_admin THEN
        RAISE EXCEPTION 'Acceso denegado: Solo los administradores pueden calcular la cantidad de peticiones de producto.';
    END IF;

    -- 🔹 Contar cuántas peticiones existen para el producto
    SELECT COUNT(*) INTO v_cantidad_peticiones
    FROM peticionProducto
    WHERE idProducto = p_idProducto;

    -- 🔹 Mostrar el resultado
    RAISE NOTICE 'El producto con ID % tiene % peticiones registradas.', p_idProducto, v_cantidad_peticiones;
END;
$$;

CALL calcular_cantidad_de_peticiones_de_producto(1, 3);


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
    WHERE idProducto = p_idProducto;

    RAISE NOTICE 'Stock actualizado correctamente. Nuevo stock: %', v_stock_actual - p_cantidadVendida;
END;
$$;

CALL actualizar_stock(5, 3, 1);


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
    
    SELECT rol INTO v_es_admin FROM usuario WHERE idusuarios = p_idAdmin;

    IF NOT v_es_admin THEN
        RAISE EXCEPTION 'Acceso denegado: Solo los administradores pueden calcular el total de un producto.';
    END IF;

    -- Obtener el precio del producto
    SELECT precio INTO v_precio_unitario FROM producto WHERE idProducto = p_idProducto;

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
