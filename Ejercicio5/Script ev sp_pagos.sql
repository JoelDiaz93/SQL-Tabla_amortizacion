/*
 * Creado: Joel Diaz*/
if OBJECT_ID('sp_pagos') is not null
begin
	drop procedure sp_pagos
end

go
create procedure sp_pagos(
	@i_cod_prestamo		varchar(10) = null,
	@i_monto		money = null,
	@i_operacion	char(1)
)
as
declare @w_numero 	int
declare @w_pago 	money
declare @w_exceso	money
declare @w_cuota    money

--I=Recuerar 2 select
if @i_operacion = 'I'
begin
	if @i_cod_prestamo is null
	begin
		raiserror('El codigo no puede ser vacio',1,5)
		return 1300
	end
	
	if (select 1 from ev_prestamo ep  where codigo  = @i_cod_prestamo) is null
	begin
		raiserror('No existe el prestamo',1,5)
		return 1300
	end
	
	select @w_numero = min(num_cuota) from ev_amortizacion ea where codigo_prestamo = @i_cod_prestamo and estado = 'P'
	select @w_cuota = cuota_adeuda from ev_amortizacion ea2 where codigo_prestamo = @i_cod_prestamo and num_cuota = @w_numero
	select @w_exceso = @i_monto - @w_cuota
	select @w_pago = @i_monto
	while @w_exceso > 0
	begin
		if @w_pago >= @w_cuota
		begin
			update ev_amortizacion 
			set
				estado = 'C',
				cuota_adeuda = 0,
				pago = @w_cuota + pago
			where codigo_prestamo = @i_cod_prestamo and num_cuota = @w_numero
		end
		else
		begin 
			update ev_amortizacion 
			set
				estado = 'P',
				cuota_adeuda = @w_cuota - @w_pago,
				pago = @w_pago
			where codigo_prestamo = @i_cod_prestamo and num_cuota = @w_numero
			return 0
		end
		
		select @w_pago = @w_pago - @w_cuota
		select @w_exceso = @w_pago - @w_cuota
		select @w_numero = @w_numero + 1
		select @w_cuota = cuota_adeuda from ev_amortizacion ea2 where codigo_prestamo = @i_cod_prestamo and num_cuota = @w_numero
	end
	
	update ev_amortizacion 
	set
		estado = 'P',
		cuota_adeuda -= @w_pago,
		pago = @w_pago + pago
	where codigo_prestamo = @i_cod_prestamo and num_cuota = @w_numero
	
end