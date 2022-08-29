exec sp_clientes @i_cedula="1231231234", @i_nombre="Carlos", @i_apellido="Rosero", @i_telefono="0976598765", @i_operacion="I"
exec sp_clientes @i_cedula="1341341223", @i_nombre="Roxana", @i_apellido="Torres", @i_telefono="0987623455", @i_operacion="I"
exec sp_clientes @i_cedula="1998787663", @i_nombre="Abigail", @i_apellido="Carrion", @i_telefono="0923871245", @i_operacion="I"
exec sp_clientes @i_cedula="1345224456", @i_nombre="Irene", @i_apellido="Novoa", @i_telefono="0977884410", @i_operacion="I"

select * from ev_clientes ec 

exec sp_prestamo @i_cedula="1998787663", @i_monto=50000, @i_plazo=12, @i_interes="INT", @i_operacion="I"
exec sp_prestamo @i_cedula="1231231234", @i_monto=5000, @i_plazo=9, @i_interes="INT", @i_operacion="I"
exec sp_prestamo @i_cedula="1341341223", @i_monto=10000, @i_plazo=36, @i_interes="INT", @i_operacion="I"
exec sp_prestamo @i_cedula="1345224456", @i_monto=200000, @i_plazo=60, @i_interes="INT", @i_operacion="I"

exec sp_prestamo @i_operacion="S", @i_codigo=21