exec sp_prestamo @i_cedula="1234567890", @i_monto=5000, @i_plazo=12, @i_interes="INT", @i_operacion="I"

declare @w_last int
select @w_last = max(codigo) from ev_prestamo ep
select * from ev_amortizacion ea where codigo_prestamo = @w_last