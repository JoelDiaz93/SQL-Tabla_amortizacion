/*
 * Creado: Joel Diaz*/
if OBJECT_ID('sp_prestamo') is not null
begin
	drop procedure sp_prestamo
end

go
create procedure sp_prestamo(
	@i_cedula		varchar(10) = null,
	@i_monto		money = null,
	@i_plazo 		int = null,
	@i_interes		varchar(5) = null,
	@i_operacion	char(1)
)
as
declare @w_valor_interes 	float
declare @W_codigo_prest 	int
declare @w_contador 		int
declare @w_interes_mensual 	float
declare @w_valor_cuota 		money
declare @w_interes_cuota 	money
declare @W_capital_ini		money
declare @w_abono_capital	money
declare @w_saldo			money
declare @w_cod_cuota		varchar(10)

--I=insertar
if @i_operacion = 'I'
begin
	if @i_cedula is null
	begin
		raiserror('La cedula no puede ser vacio',1,5)
		return 1300
	end
	if @i_monto is null
	begin
		raiserror('El monto no puede ser vacio',1,5)
		return 1300
	end
	if @i_plazo is null
	begin
		raiserror('El plazo no puede ser vacio',1,5)
		return 1300
	end
	if @i_interes is null
	begin
		raiserror('El interes no puede ser vacio',1,5)
		return 1300
	end
	
	--validar cedula
	if (select 1 from ev_clientes ec  where cedula = @i_cedula) is null
	begin
		raiserror('La cedula no existe',1,5)
		return 1300
	end
	
	select @w_valor_interes = valor from ev_parametros where codigo = @i_interes
	
	insert into ev_prestamo(
		cedula, 	monto, 		fecha_creacion, 	plazo, 		interes)
	values(
		@i_cedula, 	@i_monto, 	getDate(), 			@i_plazo, 	@w_valor_interes)
		
	select @w_codigo_prest =  max(codigo) from ev_prestamo
	select @w_contador = 1
	select @w_interes_mensual = (@w_valor_interes / 12) / 100
	select @W_capital_ini = @i_monto
	while @w_contador <= @i_plazo
	begin

		select @w_cod_cuota = cast(@w_codigo_prest as varchar) + cast(@w_contador as varchar)
		select @w_valor_cuota = (@i_monto * @w_interes_mensual) / ( 1 - (1 / (power( 1 + @w_interes_mensual, @i_plazo))))
		select @w_interes_cuota = (@W_capital_ini * ((@w_valor_interes / 12) / 100))
		select @w_abono_capital = @w_valor_cuota - @w_interes_cuota
		select @w_saldo = @W_capital_ini - @w_abono_capital
		
		insert into ev_amortizacion (
			codigo, 		codigo_prestamo, 	num_cuota, 		cuota, 			capital_inicio, 	interes, 			capital, 			saldo)
		values(
			@w_cod_cuota,	@w_codigo_prest,	@w_contador,	@w_valor_cuota,	@W_capital_ini,		@w_interes_cuota, 	@w_abono_capital,	@w_saldo)
		
		select @W_capital_ini = min(saldo) from ev_amortizacion where codigo_prestamo = @w_codigo_prest
		select @w_contador = @w_contador + 1
	end
	
	
end