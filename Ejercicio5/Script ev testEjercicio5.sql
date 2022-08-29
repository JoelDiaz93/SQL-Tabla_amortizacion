exec sp_prestamo @i_cedula="1345224456", @i_monto=3000, @i_plazo=6, @i_interes="INT", @i_operacion="I"

exec sp_pagos @i_cod_prestamo=38, @i_monto=900, @i_operacion="I"

exec sp_prestamo @i_operacion="S", @i_codigo=38


exec sp_pagos @i_cod_prestamo=38, @i_monto=60, @i_operacion="I"

exec sp_prestamo @i_operacion="S", @i_codigo=38