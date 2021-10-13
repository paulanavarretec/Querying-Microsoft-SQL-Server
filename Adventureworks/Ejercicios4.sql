
select *
from HumanResources.Employee


select 
	ProductNumber
	,[name]
	,categoria = case ProductLine
					when 'R' then 'Road'
					when 'M' then 'Montaint'
					when 'T' then 'Touring'
					when 'S' then 'Other'
					else 'N/A'
				end
	,[Rango Precios] = case
							when ListPrice = 0 then 'No dispobile'
							when ListPrice < 50 then 'Bajo $50'
							when ListPrice >= 50 and ListPrice < 500 then 'Bajo $500'
							when ListPrice >= 500 and ListPrice < 2000 then 'Bajo $2000'
							else 'Sobre $2000'
						end
from Production.Product
order by 1 

select 
	[Rango Precios] = case
							when ListPrice = 0 then 'No dispobile'
							when ListPrice < 50 then 'Bajo $50'
							when ListPrice >= 50 and ListPrice < 500 then 'Bajo $500'
							when ListPrice >= 500 and ListPrice < 2000 then 'Bajo $2000'
							else 'Sobre $2000'
						end
	,[Cantidad Productos] = count(1)
from Production.Product
group by case
			when ListPrice = 0 then 'No dispobile'
			when ListPrice < 50 then 'Bajo $50'
			when ListPrice >= 50 and ListPrice < 500 then 'Bajo $500'
			when ListPrice >= 500 and ListPrice < 2000 then 'Bajo $2000'
			else 'Sobre $2000'
		end

--------
select e.BusinessEntityID, p.FirstName + ' ' + p.LastName Nombre
from HumanResources.Employee e inner join Person.Person p
	on e.BusinessEntityID = p.BusinessEntityID
order by case e.SalariedFlag
			when 1 then p.FirstName 
		end desc
		,case e.SalariedFlag
			when 2 then p.LastName
		end

--------
select 
		cargo	= a.JobTitle
		,Genero = case a.Gender	
					when 'M' then 'Hombre'
					when 'F' then 'Mujer'
					else 'Sin información'
				end
		,Tarifa	= max(b.rate)
from HumanResources.Employee a inner join HumanResources.EmployeePayHistory b
	on a.BusinessEntityID = b.BusinessEntityID
group by a.JobTitle, a.Gender
having (max(case
				when a.gender = 'M' then b.rate
				else null
			end) > 30
		or
			max(case
					when a.gender = 'F' then b.rate
					else null
				end) > 40
		)
order by tarifa 







