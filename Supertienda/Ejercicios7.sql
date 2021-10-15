--Mostrar el modo envío menos solitado por cliente
create view ModoEnvioMenosUtilizado as
	select top 1000000
		Nombre, ModoEnvio, CantidadEnvios
	from (
		select b.Nombre, c.ModoEnvio, count(c.modoenvio) CantidadEnvios
				,row_number() over(partition by b.nombre order by count(c.modoenvio)) Orden
		from Pedidos a inner join clientes b
			on a.IDCliente = b.CODCliente
		inner join ModoEnvio c
			on c.CODModoEnvio = a.IDModoEnvio
		group by b.Nombre, c.ModoEnvio
		--order by 1, 3
		) x
	where orden = 1
	order by 1

select * from ModoEnvioMenosUtilizado

--
create view ModoEnvioPorCliente as
	select top 100000
		nombre, [En el día], [Urgente], [Semi-urgente], [Normal]
	from (
		select b.Nombre, c.ModoEnvio
		from Pedidos a inner join clientes b
			on a.IDCliente = b.CODCliente
		inner join ModoEnvio c
			on c.CODModoEnvio = a.IDModoEnvio
		--order by 1, 2
		) x
	PIVOT (
		count(ModoEnvio)
		for ModoEnvio in ([En el día], [Urgente], [Semi-urgente], [Normal])
	) y
	order by nombre

select * from ModoEnvioPorCliente

--Hacer consulta paramétrica para mostrar la cantidad de productos que se envían por categoria
--y/o modo de envío (en cualquier combinación), con y sin detalle por producto
declare @modoenvio varchar(15), @categoria varchar(50), @detalle varchar(1)

set @modoenvio = ''
set @categoria = ''
set @detalle = 'S'

if @detalle = 'N'
begin
	select a.ModoEnvio, f.Categoria, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by a.ModoEnvio, f.Categoria 
	order by 1, 2
end
else 
begin
	select a.ModoEnvio, f.Categoria, d.producto, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by a.ModoEnvio, f.Categoria, d.producto
	order by 1, 2, 3
end

---------------------
exec ModoEnvioCategoriaProducto @categoria='Muebles'

create proc ModoEnvioCategoriaProducto (@modoenvio varchar(15)='', @categoria varchar(50)='', @detalle varchar(1)='N') as

if @detalle = 'N'
begin
	select a.ModoEnvio, f.Categoria, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by a.ModoEnvio, f.Categoria 
	order by 1, 2
end
else 
begin
	select a.ModoEnvio, f.Categoria, d.producto, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by a.ModoEnvio, f.Categoria, d.producto
	order by 1, 2, 3
end

-------------
declare @modoenvio varchar(15), @categoria varchar(50), @detalle varchar(1)

set @modoenvio = ''
set @categoria = ''
set @detalle = 'S'

	select a.ModoEnvio, f.Categoria, isnull(d.producto, 'Todos') Producto, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by grouping sets (
							(a.ModoEnvio, f.Categoria, d.producto)
							,(a.ModoEnvio, f.Categoria)
							)
	having (@detalle = 'S' and producto is not null) or (@detalle = 'N' and producto is null)
	order by 1, 2, 3, 4 desc

----
exec ModoEnvioCategoriaProducto2 @detalle='S', @modoenvio='Normal'

create proc ModoEnvioCategoriaProducto2 (@modoenvio varchar(15)='', @categoria varchar(50)='', @detalle varchar(1)='N') as

	select a.ModoEnvio, f.Categoria, isnull(d.producto, 'Todos') Producto, count(d.Producto) CantidadProducto
	from modoenvio a inner join pedidos b
		on a.CODModoEnvio = b.IDModoEnvio
	inner join DetallePedido c
		on b.NroPedido = c.NroPedido
	inner join Productos d
		on d.CODProducto = c.IDProducto
	inner join subcategoria e
		on e.CODSubcategoria = d.CODSubcategoria
	inner join Categoria f
		on f.CODCategoria = e.CODCategoria
	where (a.ModoEnvio = @modoenvio and @modoenvio <> '' or a.ModoEnvio <> @modoenvio and @modoenvio = '' )
	and (f.Categoria = @categoria and @categoria <> '' or f.Categoria <> @categoria and @categoria = '')
	group by grouping sets (
							(a.ModoEnvio, f.Categoria, d.producto)
							,(a.ModoEnvio, f.Categoria)
							)
	having (@detalle = 'S' and producto is not null) or (@detalle = 'N' and producto is null)
	order by 1, 2, 3, 4 desc

--Crear una función que muestre el cliente que más ha comprado de un producto

declare @CODProducto varchar(20)
set @CODProducto = 'FUR-ADV-10000108'

select top 1 c.CODProducto, c.Producto, d.Nombre, sum(b.Cantidad) Cantidad
from pedidos a inner join detallepedido b
	on a.NroPedido = b.NroPedido
inner join productos c
	on c.CODProducto = b.IDProducto
inner join clientes d
	on d.CODCliente = a.IDCliente
where c.CODProducto = @CODProducto
group by c.CODProducto, c.Producto, d.Nombre
order by 1, 4 desc

---
create function BuscaCliente (@CODProducto varchar(20))
returns varchar(30) as
begin
	declare @cliente varchar(30)

	select @cliente = Nombre
	from (
		select top 1 c.CODProducto, c.Producto, d.Nombre, sum(b.Cantidad) Cantidad
		from pedidos a inner join detallepedido b
			on a.NroPedido = b.NroPedido
		inner join productos c
			on c.CODProducto = b.IDProducto
		inner join clientes d
			on d.CODCliente = a.IDCliente
		where c.CODProducto = @CODProducto
		group by c.CODProducto, c.Producto, d.Nombre
		order by 1, 4 desc
		) a

	return(@cliente)
end

select *, dbo.BuscaCliente(CODProducto) MejorCliente
from Productos

--==============================================================
--USO DE TRIGGERS

create table Productos_Log (
	CODProducto varchar(20) not null
	,CODSubcategoria varchar(5) not null
	,Producto varchar(100) not null
	,Operacion varchar(15) not null
	,Usuario varchar(50) not null
	,Fecha datetime
)

create trigger trProductosINS on Productos
	after insert as
begin
	insert Productos_Log
	select *, 'Inserción', system_user, getdate() from inserted
end

create trigger trProductosDEL on Productos
	after delete as
begin
	insert Productos_Log
	select *, 'Borrado', system_user, getdate() from deleted
end

--drop trigger trProductosUPD
create trigger trProductosUPD on Productos
	after update as
begin
	insert Productos_Log
	select *, 'Actualización/D', system_user, getdate() from deleted

	insert Productos_Log
	select *, 'Actualización/I', system_user, getdate() from inserted
end

select top 10 * from productos where CODProducto = 'NEW-PRD-000100'

insert into productos
select 'NEW-PRD-000100', 16, 'Producto nuevo 100'

select * from productos_log

update productos 
set producto = lower(producto)
where CODProducto = 'NEW-PRD-000100'

select top 10 * 
--delete
from productos where CODProducto = 'NEW-PRD-000001'

------------------------------------------------
create table Clientes_Log (
	CODCliente varchar(20)
	,Nombre	varchar(50)
	,IDSegmento varchar(5)
	,Operacion varchar(15) not null
	,Usuario varchar(50) not null
	,Fecha datetime
)

alter trigger trClientes on Clientes
	after insert, delete, update as
begin
	declare @ins int, @del int

	set @ins = isnull((select count(1) from inserted), 0)
	set @del = isnull((select count(1) from deleted), 0)

	if @ins > 0 and @del > 0 --actualización
	begin
		insert into Clientes_Log
		select *, 'Acualización/B', SYSTEM_USER, getdate() from deleted

		insert into Clientes_Log
		select *, 'Acualización/I', SYSTEM_USER, getdate() from inserted
	end
	if @ins > 0 and @del = 0 --inserción
	begin
		insert into Clientes_Log
		select *, 'inserción', SYSTEM_USER, getdate() from inserted
	end
	if @ins = 0 and @del > 0 --borrado
	begin
		insert into Clientes_Log
		select *, 'borrado', SYSTEM_USER, getdate() from deleted
	end
end

select * from clientes_log

select top 10 * from clientes

update clientes
set nombre = 'OTRO NOMBRE'
where CODCliente = 'AA-480'

insert into Clientes
select 'XX-999', 'NUEVO CLIENTE', 'SEG03'

select * from clientes where CODCliente = 'XX-999'

select * 
--delete
from clientes where CODCliente = 'XX-999'

--==========================================================================
select convert(varchar(8), getdate(), 112)

set language spanish

select 
	IDFecha			= convert(varchar(8), getdate(), 112)
	,Fecha			= getdate()
	,DiaSemNum		= datepart(dw, getdate())
	,DiaSemana		= datename(dw, getdate())
	,DiaMesNum		= datepart(d, getdate())
	,DiaAñoNum		= datepart(dayofyear, getdate())
	,SemanaAño		= datepart(wk, getdate())
	,MesNombre		= datename(m, getdate())
	,MesNum			= datepart(m, getdate())
	,Trimestre		= case datepart(q, getdate())
							when 1 then '1er Trimestre'
							when 2 then '2do Trimestre'
							when 3 then '3er Trimestre'
							else '4to Trimestre'
						end
	,Semestre		= iif(month(getdate()) < 7, '1er Semestre', '2do Semestre')
	,Año			= year(getdate())
	,AñoMes			= convert(varchar(4), year(getdate())) + '-' + right('0' + convert(varchar(2), month(getdate())), 2)
into Calendario

select * from calendario

alter table calendario
	alter column IDFecha varchar(8) not null

alter table calendario
	add constraint PK_Calendario primary key (IDFecha)

--
delete from Calendario
--truncate table calendario

declare @fechainicio date, @fechafin date, @fecha date

set @fechainicio = '2020-01-01'
set @fechafin = '2020-12-31'
set @fecha = @fechainicio

while @fecha <= @fechafin
begin
	insert into Calendario
	select 
	IDFecha			= convert(varchar(8), @fecha, 112)
	,Fecha			= @fecha
	,DiaSemNum		= datepart(dw, @fecha)
	,DiaSemana		= datename(dw, @fecha)
	,DiaMesNum		= datepart(d, @fecha)
	,DiaAñoNum		= datepart(dayofyear, @fecha)
	,SemanaAño		= datepart(wk, @fecha)
	,MesNombre		= datename(m, @fecha)
	,MesNum			= datepart(m, @fecha)
	,Trimestre		= case datepart(q, @fecha)
							when 1 then '1er Trimestre'
							when 2 then '2do Trimestre'
							when 3 then '3er Trimestre'
							else '4to Trimestre'
						end
	,Semestre		= iif(month(@fecha) < 7, '1er Semestre', '2do Semestre')
	,Año			= year(@fecha)
	,AñoMes			= convert(varchar(4), year(@fecha)) + '-' + right('0' + convert(varchar(2), month(@fecha)), 2)

	set @fecha = dateadd(day, 1, @fecha)
end

select * from calendario

----
exec LlenaCalendario '2021-01-01', '2021-10-14'


alter proc LlenaCalendario (@fechainicio date, @fechafin date) as

declare @fecha date
set @fecha = @fechainicio

delete from Calendario

while @fecha <= @fechafin
begin
	insert into Calendario
	select 
	IDFecha			= convert(varchar(8), @fecha, 112)
	,Fecha			= @fecha
	,DiaSemNum		= datepart(dw, @fecha)
	,DiaSemana		= datename(dw, @fecha)
	,DiaMesNum		= datepart(d, @fecha)
	,DiaAñoNum		= datepart(dayofyear, @fecha)
	,SemanaAño		= datepart(wk, @fecha)
	,MesNombre		= datename(m, @fecha)
	,MesNum			= datepart(m, @fecha)
	,Trimestre		= case datepart(q, @fecha)
							when 1 then '1er Trimestre'
							when 2 then '2do Trimestre'
							when 3 then '3er Trimestre'
							else '4to Trimestre'
						end
	,Semestre		= iif(month(@fecha) < 7, '1er Semestre', '2do Semestre')
	,Año			= year(@fecha)
	,AñoMes			= convert(varchar(4), year(@fecha)) + '-' + right('0' + convert(varchar(2), month(@fecha)), 2)

	set @fecha = dateadd(day, 1, @fecha)
end





