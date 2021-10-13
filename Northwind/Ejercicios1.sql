--1.Seleccionar los clientes que viven en el país de "usa"
select * from customers
select count(*) from customers
select top 10 * from customers
select distinct city from customers

select * from customers where country = 'usa'

--2.Seleccionar los proveedores que viven en la ciudad de "BERLIN"
select * from [dbo].[Suppliers] where city = 'berlin'

--3.Seleccionar los empleados con código 3,5 y 8
select top 10 * from Employees where EmployeeID = 3 or EmployeeID = 5 or EmployeeID = 8
select * from Employees where EmployeeID in (3,5,8)

--4.Seleccionar los productos que tienen stock mayor que cero y son del proveedor 1,3 y 5
select top 10  * from [dbo].[Products]
where UnitsInStock > 0 and SupplierID in (1,3,5)

--5.Seleccionar los productos con precio mayor o igual a 20 y menor o igual a 90
select * from products where unitprice >= 20 and unitprice <= 90
select * from products where unitprice between 20 and 90

--6.Mostrar las órdenes de compra entre las fechas 01/01/1997 al 15/07/1997
--7.Mostrar las órdenes de compra hechas en el año 1997, que pertenecen a los empleados con códigos 1 ,3 ,4 ,8
select top 10 * from Orders where orderdate >= '1997-01-01' and OrderDate <= '1997-12-31'
select top 10 * from Orders where orderdate between '19970101' and '1997/12/31'

set dateformat dmy
select top 10 * from Orders where orderdate between '01-01-1997' and '31-12/1997'

select * from orders where year(orderdate) = 1997 and EmployeeID in (1 ,3 ,4 ,8)

--8.Mostrar las ordenes hechas en el año 1996
--9.Mostrar las ordenes hechas en el año 1997 ,del mes de abril
--10.Mostrar las ordenes hechas el primero de todos los meses, del año 1998
select * from orders where day(orderdate) = 1 and year(orderdate) = 1998

--11.Mostrar todos los clientes que no tienen fax
select * from customers where fax is null
select isnull(fax, 'no tiene fax') FAX2, fax, * from customers
select isnull(fax, 'no tiene fax') 'FAX 2', fax, * from customers
select isnull(fax, 'no tiene fax') as 'FAX 2', fax FAX3, * from customers

--12.Mostrar todos los clientes que tienen fax
--13.Mostrar el nombre del producto, el precio, el stock y el nombre de la categoría a la que pertenece.
select ProductName, UnitPrice, UnitsInStock, CategoryName
from products, Categories
where products.CategoryID = categories.CategoryID

select ProductName, UnitPrice, UnitsInStock, CategoryName, p.CategoryID
from products p, Categories c
where p.CategoryID = c.CategoryID

select ProductName, UnitPrice, UnitsInStock, CategoryName, p.CategoryID
from products p inner join Categories c
	on p.CategoryID = c.CategoryID
	   
select count(1) from products
select count(*) from Categories

--14.Mostrar el nombre del producto, el precio producto, el código del proveedor y el nombre de la compañía proveedora.
--15.Mostrar el número de orden, el código del producto, el precio, la cantidad y el total pagado por producto.
--16.Mostrar el número de la orden, fecha, código del producto, precio, código del empleado y su nombre completo.
select o.OrderID, o.OrderDate, od.ProductID, od.UnitPrice, e.EmployeeID, e.FirstName + ' ' + e.LastName NombreCompleto
from orders o inner join [Order Details] od
	on o.OrderID = od.OrderID
inner join Employees e
	on o.EmployeeID = e.EmployeeID
order by UnitPrice desc


alter view OrdenesPorProducto as
select top 1000000
		o.OrderID, o.OrderDate
		,od.ProductID, od.UnitPrice
		,p.ProductName
		,e.EmployeeID, e.FirstName + ' ' + e.LastName NombreCompleto
from orders o inner join [Order Details] od
	on o.OrderID = od.OrderID
inner join Employees e
	on o.EmployeeID = e.EmployeeID
inner join Products p
	on od.ProductID = p.ProductID
order by 4 desc;


select * from OrdenesPorProducto

--17.Mostrar los 10 productos con menor stock
--18.Mostrar los 10 productos con mayor stock
--19.Mostrar los 10 productos con menor precio
--20.Mostrar los 10 productos con mayor precio
--21.Mostrar los 10 productos más baratos
--22.Mostrar los 10 productos más caros
--23.Seleccionar todos los campos de la tabla clientes,ordenar dn forma ascendente por país, descendente ciudad y ascendente por compañia
--24.Seleccionar todos los campos de clientes,cuya compania empiece con la letra B y pertenezcan a UK ,ordenar por nombre de la compania
--25.Seleccionar todos los campos de productos de las categorias 1,3 y 5,ordenar por categoria
--26.Seleccionar los productos cuyos precios unitarios estan entre 50 y 200
--27.Visualizar el nombre y el id de la compania del cliente,fecha,precio unitario y producto de la orden
--28.Seleccionar los jefes de los empleados
--29.Obtener todos los productos cuyo nombre comienzan con M y tienen un precio comprendido entre 28 y 129
--30.Obtener todos los clientes del Pais de USA,Francia y UK
--31.Obtener todos los productos descontinuados o con stock cero.
--32.Obtener todas las ordenes hechas por el empleado King Robert
--33.Obtener todas las ordenes por el cliente cuya compania es "Que delicia"
--34.Obtener todas las ordenes hechas por el empleado King Robert,Davolio Nancy y Fuller Andrew
--35.Obtener todos los productos(codigo,nombre,precio,stock) de la orden 10257
--36.Obtener todos los productos(codigo,nombre,precio,stock) de las ordenes hechas desde 1997 hasta la fecha de hoy.
--37.Mostrar los 10 productos que más aumentarion de precio, su variación y porcentaje
--38.Obtener el nombre de todas las categorias y los nombres de sus productos,precio y stock.
--39.Obtener el nombre de todas las categorias y los nombres de sus productos, solo los productos que su nombre no comience con la letra P
--40.Calcular el stock de productos por cada categoria.Mostrar el nombre de la categoria y el stock por categoria, ordenado por el stock descendente
--41. Seleccionar todos aquellos clientes que han comprado productos descontinuados
--42.Obtener el Nombre del cliente,Nombre del Proveedor,Nombre del empleado y el nombre de los productos que estan en la orden 10794
--43.Seleccionar el nombre de la compañía del cliente,él código de la orden de compra,la fecha de la orden de compra, código del
--   producto, cantidad pedida del producto,nombre del producto, el nombre de la compañía proveedora y la ciudad del proveedor.
--44.Seleccionar el nombre de la compañía del cliente, nombre del contacto, el código de la orden de compra, la fecha de la orden de
--   compra, el código del producto,cantidad pedida del producto, nombre del producto y el nombre de la compañía proveedora.
--   Solamente las compañías proveedoras que comienzan con la letra de la A hasta la letra G,además la cantidad pedida del producto debe estar entre 23 y 187.
--45.Selecionar los proveedores por región 
--46.Mostrar a quién reporta cada empleado ordernado por cargo 
--47.Listar todos los clientes, productos que consumen y proveedor de productos marinos.
--48.Mostrar la cantidad de ventas, productos, clientes, venta total, venta promedio, venta mínima y máxima, 
--   además del rango de fechas para las ventas realizadas en la zona (territorio) de New York
--49.Selecione el servicio de entrega (Shippers) en que la ciudad de entrega corresponda a la misma ciudad del proveedor del producto, 
--   indicando: país, ciudad y deirección del proveddor y de la orden de compra
--50.Haga una consulta que sirva para exportar todos los datos de la base de datos a un archivo, sin repetir campos ni códigos (ID's), salvo el número de Orden.
