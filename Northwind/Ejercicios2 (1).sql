--1. Mostrar cuántos clientes existen en cada País.
select Country, count(CustomerID) CantidadClientes
from Customers
group by Country
order by CantidadClientes desc

--2. Mostrar cuántos proveedores existen en cada Ciudad y País.
select country, City, count(*)
from Suppliers
group by country, City

select * from Suppliers

--3. Mostrar el numero de ordenes de cada uno de los clientes por año,luego ordenar codigo del cliente y el año.
select c.CompanyName, year(o.OrderDate), count(*)
from Orders o inner join customers c
	on c.CustomerID = o.CustomerID
group by c.CompanyName, year(o.OrderDate)
order by 3 desc

--4. Visualizar el nombre de la categoria y el numero de productos que hay por cada categoria.
select c.CategoryName, count(*) as [Total Productos]
from Categories c inner join Products p
	on c.CategoryID = p.CategoryID
group by c.CategoryName
order by 2 desc

--5. Contar el numero de ordenes que se han realizado por años y meses, luego debe ser ordenado por año y por mes.
select year(orderdate) AÑO, month(orderdate) MES, count(1) 'Cantidad de Ordenes'
from Orders
group by year(orderdate), month(orderdate) 
order by AÑO desc, MES asc

--6. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la categoría y el stock por categoría.
select top 5
	c.CategoryName, sum(p.UnitsInStock) Cantidad
from Products p inner join Categories c
	on p.CategoryID = c.CategoryID
group by c.CategoryName
order by 2 desc

--7. Seleccionar los 5 productos mas vendidos
--8. Seleccionar las categorías que tengan más 10 productos. Mostrar el nombre de la categoría y el número de productos.
select c.CategoryName, count(*) Cantidad
from Products p inner join Categories c
	on p.CategoryID = c.CategoryID
group by c.CategoryName
having count(*) > 10

--9. Calcular el stock total de los productos por cada categoría. Mostrar el nombre de la
--   categoría y el stock por categoría. Solamente las categorías 2, 5 y 8.
create view ProductosPorCategoria as
select c.categoryid, c.CategoryName, sum(p.UnitsInStock) Cantidad
from Products p inner join Categories c
	on p.CategoryID = c.CategoryID
where c.CategoryID in (2, 5, 8)
group by c.categoryid, c.CategoryName

select * from ProductosPorCategoria


select OrderID, sum(Quantity * UnitPrice) TotalOrden
from [Order Details]
group by OrderID
having sum(Quantity * UnitPrice) > 1000

--10. Mostrar el numero de ordenes realizadas de cada uno de los clientes por mes y año.
--11. Mostrar el número de órdenes realizadas de cada uno de los empleados en cada territorio.
--12. Seleccionar cuantos proveedores tengo en cada país, considerando solo a los nombre de los proveedores que comienzan 
--    con la letra E hasta la letra P, además de mostrar solo los países donde tenga más de 2 proveedores.
select Country, count(*) CantidadProveedores
from Suppliers
where CompanyName like '[e-p]%'
group by Country
having count(*) > 2
order by 2 desc

--13. Obtener el número de productos, por cada categoría. Mostrando el nombre de la categoría, el nombre del producto y el total de
--    productos por categoría, solamente de las categorías 3, 5 y 8. Ordenar por el nombre de la categoría.
--14. Hacer una consulta paramétrica que muestre los productos que se encuentra en un rango de precios 
declare @PrecioDesde int, @PrecioHasta int
set @PrecioDesde = 50
set @PrecioHasta = 100

select *
from products
where unitprice between @PrecioDesde and @PrecioHasta

--16. Hacer una consulta paramétrica que muestre la cantidad de unidades vendidas por empleado por un año determinado
declare @año int, @unidades int
set @año = 1996
set @unidades = 1000


select year(o.orderdate) Año, e.FirstName + ' ' + e.LastName Empleado, sum(od.Quantity) UnidadesVendidas
from Employees e inner join orders o
	on e.EmployeeID = o.EmployeeID
inner join [Order Details] od
	on od.OrderID = o.OrderID
where year(o.orderdate) = @año
group by year(o.orderdate), e.FirstName + ' ' + e.LastName
having sum(od.Quantity) > @unidades 
order by 3 desc


--17. Hacer una consulta parámetrica que muestre los productos mas vendidos por año segun el numero de registros "N" que 
--    se quieere mostrar y mostrar en monto vendido
--18. Mostrar en una consulta parámetrica los productos no vendidos en un año o preeveedor determinado
declare @año int, @proveedor nvarchar(40)
set @año = 1997
set @proveedor = 'Bigfoot Breweries'

select *
from Products
where ProductID in (
	select distinct p.ProductID
	from [Order Details] od inner join orders o
		on od.OrderID = o.OrderID
	inner join Products p
		on od.ProductID = p.ProductID
	inner join Suppliers s
		on s.SupplierID = p.SupplierID
	where year(o.OrderDate) = @año
	and s.CompanyName = @proveedor
)

select * from Suppliers

--19. Hacer una consulta paramétrica para buscar productos de acuerdo a un patrón y mostrar como resultado el empleado
--    y la cantidad de productos vendidos y el nombre del o los productos

alter procedure BuscaProductos (@buscar nvarchar(40)) as 

set @buscar = concat('%', @buscar, '%')

select concat(e.FirstName, ' ', e.LastName) Empleado, p.ProductName, sum(od.Quantity) Cantidad
from orders o inner join [Order Details] od
	on o.OrderID = od.OrderID
inner join Employees e
	on e.EmployeeID = o.EmployeeID
inner join Products p
	on p.ProductID = od.ProductID
where p.ProductName like @buscar
group by concat(e.FirstName, ' ', e.LastName), p.ProductName
order by 1, 3 desc


exec BuscaProductos 'x'


--20. En una consulta parametrica mostrar la orden y los dias transcurridos entre el requerimiento y el despacho 
--    para un rango de fechas dados

alter proc buscaordenes (@FechaDesde date, @FechaHasta date) as

select 'Rango de  busqueda: ' + convert(varchar, @FechaDesde) + ' - ' + cast(@FechaHasta as varchar) RangoFechas

select OrderID, datediff(day, ShippedDate, RequiredDate) Dias
from Orders
where OrderDate between @FechaDesde and @FechaHasta


exec buscaordenes '1997-10-01', '1997-10-31'



select * from orders