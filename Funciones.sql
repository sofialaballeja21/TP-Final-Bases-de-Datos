-- calcular_cantidad_de_peticiones_de_producto
create or replace function calcular_cantidad_de_peticiones_de_producto (
 p_idproducto int)
returns bigint as $$ --bigint devuelve un nro entero grande

declare 
     cantidad_peticiones int;

begin
	select COUNT(*) into cantidad_peticiones
	from peticionProducto
	where idProducto = p_idproducto;
	
	return cantidad_peticiones;
	
end;
$$ language plpgsql;

-- cargar una reseña
create or replace function cargar_una_resenia (
u_idusuario int, p_idproducto int, r_comentario text, r_resenia int)
returns text as $$

declare
    producto_existente Boolean;
    usuario_existente boolean;

begin

   select exists 
   (select 1 from producto where idProducto = p_idproducto) into producto_existente;
   if not producto_existente then
    return 'Error: el producto con id' || p_idProducto || ' no existe.';
   end if;

   select exists 
   (select 1 from usuario where idUsuario = u_usuario) into usuario_existente;
   if not usuario_existente then
     return 'Error: El usuario con id' || u_idusuario || ' no existe.';
   end if;

   if r_resenia < 1 or r_resenia > 5 then
     return 'Error: La reseña debe ser entre 1 y 5';
   end if;

   insert into reseniaComentario(idProducto, idUsuario, comentario, resenia) 
   values (p_idproducto, u_idusuario, r_comentario, r_resenia);
   return 'Reseña cargada correctamente';
  exception 
   when others then
    return 'Error inesperado al cargar la reseña' || SQLERRM;

end;
$$ language plpgsql;


-- Función para agregar productos al carrito
create or replace function agregar_productos_al_carrito (
p_idprodcuto int, c_idcarrito int, u_idusuario int, p_cantidad int)
returns TEXT as $$
declare 
  v_idCarrito int;
  v_stockProducto int;
  v_cantidad_en_carrito int;
  v_nombreProducto varchar(50);
begin
	-- obtener el idcarrito del usuario
	select idCarrito into v_idcarrito
	from usuario
	where idusuarios = u_idusuario;
	
	if  c_carrito is null then
	  return 'Error: El usuario no tiene un carrito asignado';
	end if;
	
	-- obtener el stock actual del producto y su nombre
	select stock.p, nombre.p into v_stockProducto, v_nombreProducto 
	from producto p 
	where idproducto == p_idproducto;
	
	if stock == 0 then
	 return 'No hay stock disponible';
	end if;
	
	-- verificar si hay suficiente stock
	if p_cantidad <= 0 then
	  return 'Error la cantidad debe ser mayor que 0';
	end if;
	
	if v_stockProducto < p_cantidad then 
	RETURN 'Error: No hay suficiente stock de ' || v_nombreProducto || '. Stock disponible: ' || v_stockProducto || '.';
    END IF;
	
	-- verificar si el producto esta en el carrito
	select cantidad into v_cantidad_en_carrito
	from productoxcarrito 
	where idCarrito = v_idcarrito and idProducto = p_idproducto;
	
	if v_cantidad_en_carrito is not null then
	   IF (v_cantidad_en_carrito + p_cantidad) > v_stockProducto THEN
          RETURN 'Error: Agregar ' || p_cantidad || ' unidades de ' || v_nombreProducto || ' excede el stock disponible. Tienes ' || v_cantidad_en_carrito  || ' en el carrito. Stock total: ' || v_stockProducto || '.';
       END IF;
	  
	   update productoxcarrito p 
	   set cantidad = cantidad + p_cantidad
	   where idCarrito = v_idcarrito and idProducto = p_idproducto;
	
	else
	  insert into productoxcarrito (idproductoxcarrito, idProducto, cantidad)
	  values (V_idCarrito, p_idProducto, p_cantidad);
	
	  return 'Producto' || v_nombreProducto || ' agregado al carrito exitosamente.';
    END IF;
	  
    exception
       when others then
          return 'Error inesperado: ' sqlerrm; 
end;
$$ language plpgsql;

   
