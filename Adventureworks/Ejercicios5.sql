select *
--delete
from Products
where ProductID = 50

select *
--into RespaldoDetalleOrden
--delete
from [Order Details]
where ProductID = 50

select *
--delete
from respaldoproducto
where ProductID = 50

select *
--delete
from Suppliers
where SupplierID = 10

select *
--delete
from Products
where SupplierID = 10

select *
--delete
from [Order Details]
where ProductID = 24

---
select * 
--update c set ContactName = 'Aquiles C' 
from customers c
where customerid = 'BOLID'

--update customers set ContactName = 'Joaquin Kong' 
where customerid = 'BOLID'


select * from customers

--
select * 
--update c set customerid = 'XX300' 
--delete c
from customers c
where customerid = 'BOLID'

insert into customers 
select 'XX300', CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, Country, Phone, fax 
from customers c
where customerid = 'BOLID'


select *
--update o set customerid = 'XX300' 
from orders o
where CustomerID = 'BOLID'

--
select * from customers

insert into customers (CustomerID, CompanyName)
values('XX400', 'Compañia 1')

select * from customers where CustomerID = 'XX400'

insert into customers (City, CompanyName, CustomerID)
values('Santiago', 'Compañía 2', 'XX500')

select * from customers where CustomerID = 'XX500'

insert into Customers (CustomerID, CompanyName)
select 
	'XX50' + convert(varchar, row_number() over(order by customerid))
	,CompanyName
from customers
where CustomerID like 'B%'

select * from Customers where Customerid like 'XX%'

select * from orders

insert into orders
values('XX501', 5, getdate()
	, getdate(), getdate(), 1, null, null
	, null, null, null, null, null)


select * from orders where customerid = 'XX501'

select * from products

insert into RespaldoProducto
select 'Producto X', 10, 99, 'Cajas', 33.33, 100, 50, null, 0

select * from RespaldoProducto where ProductName = 'Producto X'

insert into Products
select 'Producto X', 11, 9, 'Cajas', 33.33, 100, 50, null, 0

select * from Products where ProductName = 'Producto X'

select * from Categories

insert into Categories
values ('Categoria New', 'nueva categoria', null)

select * from Suppliers

---
--drop table cliente
create table cliente (
	CODCliente varchar(10) not null
	,Nombre varchar(40) default('Sin informacion')
	,FechaIngreso date not null
	,VIP int default(0)
	,constraint PK_Cliente primary key (CODCliente)
)

--insert into cliente 
--insert into cliente (CODCliente, Nombre, FechaIngreso)
insert into cliente (CODCliente, FechaIngreso)
--select 'C001', 'Cliente 1', getdate(), null
--select 'C002', 'Cliente 1', '2020-10-10'
--select 'C002', null, null, null
--select null, 4444, getdate(), 88
select 'C003', getdate()

select * from cliente

---
--drop table venta
create table venta (
	CODVenta int identity(1,1) not null
	,FechaVenta date default(getdate())
	,IDCliente varchar(10) not null
	,CODProducto varchar(5)
	,Cantidad int
	,PrecioUnitario float
	,constraint PK_Venta primary key (CODVenta, IDCliente)
	,constraint FK_VentaCliente foreign key (IDCliente) references cliente(CODCliente)
	,constraint FK_VentaProducto foreign key (CODProducto) references producto(NroProducto)
)

insert into venta (IDCliente, CODProducto, Cantidad)
select 'C001', 'P999', 45

select * from venta

alter table venta
	add constraint FK_VentaProducto foreign key (CODProducto) references producto(NroProducto)

insert into venta
select getdate(), 'C003', 'P001', null, null

select * from venta

--
--drop table producto
create table producto (
	NroProducto varchar(5) not null
	,Descripcion varchar(100)
	,Vigente varchar(1) default('S')
	,constraint PK_Producto primary key (NroProducto)
)

insert into producto 
--values('P001', 'Producto 1', 'S')
values('P999', 'Producto 999', 'S')

select * from producto

alter table producto
	add Stock int

alter table producto
	add fechavigencia date default(getdate())

