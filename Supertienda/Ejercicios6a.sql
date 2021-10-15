--drop table Segmento
create table Segmento (
	CODSegmento varchar(5)
	,Segmento varchar(30)
	,constraint PK_Segmento primary key (CODSegmento)
)

select * from supertienda

insert into segmento
select distinct 
	case segmento
		when 'Consumidor' then 'SEG01'
		when 'PYMES' then 'SEG02'
		when 'Empresas grandes' then 'SEG03'
		else 'SEG99'
	end
	,segmento
from supertienda

select * from segmento

--=============================================
--drop table clientes
create table Clientes (
	CODCliente varchar(20)
	,Nombre	varchar(50)
	,IDSegmento varchar(5)
	,constraint PK_Cliente primary key (CODCliente)
	,constraint FK_ClienteSegmento foreign key (IDSegmento) references Segmento(CODSegmento)
)

select * from clientes

insert into clientes
select distinct 
	id_cliente
	,cliente
	,b.CODSegmento
from Supertienda a inner join segmento b
	on a.segmento = b.segmento

--drop table Pais
create table Pais (
	CodigoPais varchar(10)
	,Pais varchar(30)
	,constraint PK_Pais primary key (CodigoPais)
)

insert into Pais
select 
	upper(substring(pais, 1, 3)) + right('00' + convert(varchar(3), row_number() over(order by pais)), 3) CodigoPais
	,substring(pais, 1, 30)
from Supertienda
group by pais
order by pais

select * from pais

--========================================
--drop table ciudad 
create table Ciudad (
	CODCiudad varchar(10)
	,CodigoPais varchar(10)
	,Ciudad varchar(30)
	,constraint PK_Ciudad primary key (CODCiudad)
	,constraint FK_CiudadPais foreign key (CodigoPais) references pais(CodigoPais)
)

insert into ciudad
select 
		upper(substring(ciudad, 1, 3)) + right('000' + convert(varchar(4), row_number() over(order by ciudad)), 4) CodigoCiudad
		,b.codigopais
		,substring(ciudad, 1, 30)
from Supertienda a inner join pais b
	on a.pais = b.pais
group by b.codigopais, ciudad

select * from ciudad

--========================================================
--drop table ModoEnvio
create table ModoEnvio (
	CODModoEnvio varchar(4)
	,ModoEnvio varchar(15)
	,constraint PK_ModoEnvio primary key (CODModoEnvio)
)

insert into ModoEnvio
select distinct
	case Modo_Envío
		when 'Urgente' then 'ME01'
		when 'Normal' then 'ME02'
		when 'Semi-urgente' then 'ME03'
		when 'En el día' then 'ME04'
		else 'ME99'
	end
	,Modo_Envío
from supertienda

select * from ModoEnvio
--===============================================
--drop table Pedidos
create table Pedidos (
	NroPedido varchar(15) not null
	,IDCliente varchar(20) not null
	,IDModoEnvio varchar(4) not null
	,FechaPedido date 
	,FechaDespacho date
	,CiudadDespacho varchar(10) not null
	,constraint PK_Pedidos primary key (NroPedido)
	,constraint FK_PedidosCliente foreign key (IDCliente) references Clientes(CODCliente)
	,constraint FK_PedidosCiudad foreign key (CiudadDespacho) references Ciudad(CODCiudad)
	,constraint FK_PedidosModoEnvio foreign key (IDModoEnvio) references ModoEnvio(CODModoEnvio)
)

insert into Pedidos
select distinct
	NroPedido		= a.ID_Pedido
	,IDCliente		= b.CODCliente
	,IDModoEnvio	= c.CODModoEnvio
	,FechaPedido	= a.Fecha_Pedido
	,FechaDespacho	= a.Fecha_Envío
	,CiudadDespacho = d.CODCiudad
from Supertienda a inner join clientes b
	on a.ID_Cliente = b.CODCliente
inner join ModoEnvio c
	on a.Modo_Envío = c.ModoEnvio
inner join ciudad d
	on d.Ciudad = a.Ciudad
inner join Pais e
	on d.CodigoPais = e.CodigoPais
	and e.Pais = a.Pais
where a.ID_Pedido not in (
	select
		ID_Pedido--, count(1)
	from (
			select distinct
				ID_Pedido, ID_Cliente
			from Supertienda
		) a
	group by ID_Pedido
	having count(1) > 1
	--order by 2 desc
	)
and ID_Pedido <> 'ES-2014-1903302'

select * from supertienda where ID_Pedido = 'ES-2014-1903302'

