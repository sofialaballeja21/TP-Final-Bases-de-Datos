-- 1 Trigger para que una vez que confirma el pago se envía el código de seguimiento.
         --- El codigo de seguimiento debe ser generado al azar
create or replace function  generar_y_enviar_codigo_de_seguimiento ()
returns trigger as $$
declare 
   nuevo_codigo varchar(10);
   codigo_existe Boolean;

begin
   nuevo_codigo := (floor(random() * 9000000000 + 1000000000)::bigint)::text AS numero_aleatorio;
   select exists (select 1 from codigoSeguimiento where codigo = nuevo_codigo)
          into codigo_existe;

   if not codigo_existe then 
      insert into codigoSeguimiento (codigo)
          values(nuevo_codigo);
      return 'Su codigo de seguimiento es: ' || nuevo_codigo;
   end if;
   
   return  new;      
end
$$ language plpgsql;

create trigger trigger_generar_y_enviar_codigoSeguimiento
before update on factura
for each row
when (new.estadoFactura = 'pagado' and old.estadoFactura is distinct from 'pagado')
execute function generar_y_enviar_codigo_de_seguimiento();


-- 2 Trigger de "confirmar compra":
         --- Si al momento de hacer la compra ya no esta disponible que envíe un mensaje y lo quite.
         --- De los que si hay stock, Disminuir el stock una vez confirmada la compra.     
         --- (ver si es necesario)- Las forma de pago están predeterminada como en transferencia o tarjeta (api de mercado pago)
         --- calcular_total compra
         --- Se calcula automáticamente el impuesto como el 21% del PagoTotal.
         --- crear una factura una vez confirmada la compra
     
 -- 3 Trigger actualizar_stock cuando se carga un ingreso
