create table Categoria (
	CODCategoria varchar(10) not null
	,Categoria varchar(50) not null
	,constraint PK_Categoria primary key (CODCategoria)
)

insert into categoria
select distinct	
	case categoría
		when 'Material de Oficina' then 'CAT001'
		when 'Tecnología' then 'CAT002'
		when 'Muebles' then 'CAT003'
		else 'CAT999'
	end
	,categoría
from Supertienda

--
create table Subcategoria (
	CODCategoria varchar(10) not null
	,CODSubcategoria varchar(5) not null
	,Subcategoria varchar(50) not null
	,constraint PK_Subcategoria primary key (CODSubcategoria)
	,constraint FK_SubcategoriaCategoria foreign key (CODCategoria) references Categoria(CODCategoria)
)

insert into Subcategoria
select
	b.CODCategoria
	,row_number() over(order by b.CODCategoria)
	,a.Sub_Categoría
from supertienda a inner join categoria b
	on a.Categoría = b.Categoria
group by b.CODCategoria, a.Sub_Categoría

--==================================

create table Productos (
	CODProducto varchar(20) not null
	,CODSubcategoria varchar(5) not null
	,Producto varchar(100) not null
	,constraint PK_Producto primary key (CODProducto)
	,constraint FK_ProductoSubcategoria foreign key (CODSubcategoria) references Subcategoria(CODSubcategoria)
)

select top 10 * from supertienda

insert into Productos
select distinct
	a.ID_Arteículo
	,b.CODSubcategoria
	,substring(a.Producto, 1, 100)
from Supertienda a inner join  Subcategoria b
	on a.Sub_Categoría = b.Subcategoria
where a.ID_Arteículo not in (
								select ID_Arteículo--, count(1)
								from (
									select distinct
										a.ID_Arteículo
										,b.CODSubcategoria
										,substring(a.Producto, 1, 100) Producto
									from Supertienda a inner join  Subcategoria b
										on a.Sub_Categoría = b.Subcategoria
									) x
								group by ID_Arteículo
								having count(1) > 1
								--order by 2 desc
							)

select distinct
	a.ID_Arteículo
	,b.CODSubcategoria
	,substring(a.Producto, 1, 100)
from Supertienda a inner join  Subcategoria b
	on a.Sub_Categoría = b.Subcategoria
where a.ID_Arteículo = 'OFF-PA-10004673'

--=============================================
create table DetallePedido (
	NroPedido varchar(15) not null
	,Linea int not null
	,IDProducto varchar(20) not null
	,Cantidad int
	,PrecioUnitario money
	,Margen money
	,Descuento decimal(5,3)
	,CostoEnvio money
	,constraint PK_DetallePedido primary key (Nropedido, Linea)
	,constraint FK_DetallePedido foreign key (IDProducto) references Productos(CODProducto)
)

select top 10 * from supertienda

insert into DetallePedido
select 
	NroPedido = id_pedido
	,Linea = row_number() over(partition by id_pedido order by id_pedido)
	,IDProducto = id_arteículo
	,Cantidad = cantidad
	,PrecioUnitario = ventas
	,Margen = beneficio
	,Descuento = convert(money, replace(Descuento, ',', '.'))
	,CostoEnvio = Coste_envío
from supertienda a 
where exists(select 1 from Productos b
				where b.CODProducto = a.ID_Arteículo)

--===============================

select ID_Arteículo, count(1)
from (
	select distinct
		a.ID_Arteículo
		,b.CODSubcategoria
		,substring(a.Producto, 1, 100) Producto
	from Supertienda a inner join  Subcategoria b
		on a.Sub_Categoría = b.Subcategoria
	) x
group by ID_Arteículo
having count(1) > 1
order by 2 desc


select distinct
	a.ID_Arteículo
	,substring(a.Producto, 1, 100)
from Supertienda a inner join  Subcategoria b
	on a.Sub_Categoría = b.Subcategoria
where a.ID_Arteículo = 'OFF-PA-10004673'

select ID_Arteículo, len(ID_Arteículo) from Supertienda order by 2 desc

--CURSORES
declare @CODProducto varchar(20)

declare recorre cursor for
	select ID_Arteículo --, count(1)
	from (
		select distinct
			a.ID_Arteículo
			,b.CODSubcategoria
			,substring(a.Producto, 1, 100) Producto
		from Supertienda a inner join  Subcategoria b
			on a.Sub_Categoría = b.Subcategoria
		) x
	group by ID_Arteículo
	having count(1) > 1
	--order by 2 desc
open recorre 
fetch next from recorre into @CODProducto
while @@fetch_status = 0
begin
	insert into Productos
	select ID_Arteículo + '-' + convert(varchar(2), row_number() over(order by id_arteículo))
			,b.CODSubcategoria
			,substring(Producto, 1, 100)
	from supertienda a inner join subcategoria b
		on a.Sub_Categoría = b.Subcategoria
	where ID_Arteículo = @CODProducto
	group by ID_Arteículo, b.CODSubcategoria, Producto

	fetch next from recorre into @CODProducto
end

close recorre
deallocate recorre

--==============================================

--CICLO WHILE
declare @contador int
set @contador = 1

while 1 = 1 --@contador < 100
begin 
	--select @contador

	select top (@contador) * from Supertienda

	set @contador = @contador + 1
end

--====================================================

insert into DetallePedido
select 
	NroPedido = id_pedido
	,Linea = row_number() over(partition by id_pedido order by id_pedido)
				+ isnull((select max(linea) from DetallePedido x where x.NroPedido = a.ID_Pedido), 0)
	,IDProducto = b.CODProducto
	,Cantidad = cantidad
	,PrecioUnitario = ventas
	,Margen = beneficio
	,Descuento = convert(money, replace(Descuento, ',', '.'))
	,CostoEnvio = Coste_envío
from supertienda a inner join (
							select distinct p.CODProducto, p.Producto
							from Productos p left join DetallePedido d
								on p.CODProducto = d.IDProducto
							where d.IDProducto is null) b
	on a.Producto = b.Producto


select * 
from DetallePedido 
where len(idproducto) > 16


select *
from Productos
where CODProducto in (
		select s.ID_Arteículo
		from DetallePedido d right join Supertienda s
			on d.NroPedido = s.ID_Pedido
			and d.IDProducto = s.ID_Arteículo
		where d.NroPedido is null
		)


select distinct --s.*
	s.ID_Arteículo, s.Sub_Categoría, s.Producto
from DetallePedido d inner join productos p
	on d.IDProducto = p.CODProducto
right join Supertienda s
	on d.NroPedido = s.ID_Pedido
	and p.Producto = s.Producto
where d.NroPedido is null

insert into Productos
select distinct 
	s.ID_Arteículo, x.CODSubcategoria, substring(s.Producto, 1, 100)
from DetallePedido d inner join productos p
	on d.IDProducto = p.CODProducto
right join Supertienda s
	on d.NroPedido = s.ID_Pedido
	and p.Producto = s.Producto
inner join Subcategoria x
	on x.Subcategoria = s.Sub_Categoría
where d.NroPedido is null
and not exists(select 1
				from productos z
				where s.ID_Arteículo = z.CODProducto)

select *
from Productos
where CODProducto in (
'TEC-PH-10001552'
,'TEC-PH-10003601'
)

insert into DetallePedido
select 
	NroPedido = s.id_pedido
	,Linea = row_number() over(partition by id_pedido order by id_pedido)
				+ isnull((select max(linea) from DetallePedido x where x.NroPedido = s.ID_Pedido), 0)
	,IDProducto = s.ID_Arteículo
	,Cantidad = s.cantidad
	,PrecioUnitario = ventas
	,Margen = beneficio
	,Descuento = convert(money, replace(s.Descuento, ',', '.'))
	,CostoEnvio = Coste_envío
from DetallePedido d inner join Productos p
	on d.IDProducto = p.CODProducto
right join Supertienda s
	on d.NroPedido = s.ID_Pedido
	and p.Producto = s.Producto
where d.NroPedido is null
and s.ID_Arteículo in (select CODProducto from productos)
							

--
alter table DetallePedido
	add constraint FK_DetallePedidoPedidos foreign key (NroPedido) references Pedidos(NroPedido)

select distinct b.NroPedido
--delete b
from pedidos a right join DetallePedido b
	on a.NroPedido = b.NroPedido
where a.NroPedido is null




