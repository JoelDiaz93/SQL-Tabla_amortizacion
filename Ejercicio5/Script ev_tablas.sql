/*
 * Creado: Joel Diaz
 */

-- Tabla cliente
if OBJECT_ID('ev_clientes') is not null
begin
	drop table ev_clientes	
	print 'entra borrando'
end
 
create table ev_clientes(
	cedula 		varchar(10) not null primary key,
	nombre 		varchar(100) not null,
	apellido 	varchar(100) not null,
	telefono 	varchar(10) not null
)

Select * from ev_clientes

-- Tabla prestamo
if OBJECT_ID('ev_prestamo') is not null
begin
	drop table ev_prestamo	
	print 'entra borrando'
end
 
create table ev_prestamo(
	codigo 			int identity(1,1) not null primary key,
	cedula 			varchar(10) not null foreign key references ev_clientes(cedula),
	monto 			money not null,
	fecha_creacion 	date not null,
	plazo			int not null,
	interes 		float not null,
)
alter table ev_prestamo add unique(codigo)

Select * from ev_prestamo 

-- Tabla parametros
if OBJECT_ID('ev_parametros') is not null
begin
	drop table ev_parametros	
	print 'entra borrando'
end
 
create table ev_parametros(
	codigo		varchar(5) not null,
	descripcion	varchar(100) not null,
	valor 		float not null
)

insert into ev_parametros(
	codigo,	descripcion,				valor)
values(
	'INT', 	'Tasa de interes anual',	12)

Select * from ev_parametros

-- Tabla amortizacion
if OBJECT_ID('ev_amortizacion') is not null
begin
	drop table ev_amortizacion	
	print 'entra borrando'
end
 
create table ev_amortizacion(
	codigo 			varchar(10) not null primary key,
	codigo_prestamo	int not null foreign key references ev_prestamo(codigo),
	num_cuota		int not null,
	cuota			money not null,
	capital_inicio	money not null,
	interes			money not null,
	capital			money not null,
	saldo			money not null,
	pago			money,
	estado			char(1),
	cuota_adeuda	money,
)

Select * from ev_amortizacion 