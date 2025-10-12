-- Practica 1 : Programa Registros
-- Declaracion del paquete estandar
with Ada.Text_Io; use Ada.Text_Io;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_Io.Unbounded_Io; use Ada.Text_Io.Unbounded_Io;

-- Procedimiento Principal
procedure registros is
	 -- Declaracion de tipos
	 type dia_t is range 1..31;
	 type mes_t is (enero, febrero, marzo, abril, mayo, junio, julio, agosto, septiembre, octubre, noviembre, diciembre);
	 type anno_t is range 2000..2025;
	 type fecha_t is record
	 	Dia : dia_t;
	 	Mes : mes_t;
	 	Anno : anno_t;
	 end record;

	 type nota_t is delta 0.1 range 0.0..10.0;

	 type pelicula_t is record
	 	Titulo : Unbounded_String;
	 	Fecha : fecha_t;
	 	Nota : nota_t;
	 end record;
	 
	 type array_peliculas_t is array (integer range <>) of pelicula_t;

	 -- Declaracion de paquetes
	 package Ent_ES is new Ada.Text_Io.Integer_Io(Integer);
	 
	 package Dia_ES is new Ada.Text_Io.Integer_Io(dia_t);
	 package Mes_ES is new Ada.Text_Io.Enumeration_Io(mes_t);
	 package Anno_ES is new Ada.Text_Io.Integer_Io(anno_t);
	 package Nota_ES is new Ada.Text_Io.Fixed_Io(nota_t);
	 
	 package Float_ES is new Ada.Text_Io.Float_Io(Float);
	 
	 -- Declaracion de variables locales
	 n_registros : Integer;
	 nueva_pelicula, pelicula_minima, pelicula_maxima, primera_pelicula, ultima_pelicula: pelicula_t;
	 nueva_fecha : fecha_t;
	 array_peliculas : array_peliculas_t(1..100); --Elijo un tamano fijo max luego usuario elige cuantos registros
	 notas : float := 0.0;
	 nota_media : Float;
	 
 begin
	 -- Entrada de los datos
	 Put("Introduce el numero de registros:");
	 Ent_Es.Get(n_registros);
	 Skip_Line;
	 
	 
 	 for i in 1..n_registros loop
 	 	Put("Introduce nombre de la pelicula:");
 	 	Get_Line(nueva_pelicula.Titulo);
 	 	Skip_Line;
 	 	
	 	Put("Introduce el dia que alquilaste la pelicula:");
	 	Dia_ES.Get(nueva_fecha.Dia);
	 	Skip_Line;
	 	Put("Introduce el mes que alquilaste la pelicula:");
	 	Mes_ES.Get(nueva_fecha.Mes);
	 	Skip_Line;
	 	Put("Introduce el anno que alquilaste la pelicula:");
	 	Anno_ES.Get(nueva_fecha.Anno);
	 	Skip_Line;
	 	nueva_pelicula.Fecha := nueva_fecha;
	 	
	 	Put("Introduce la nota de la pelicula:");
	 	Nota_ES.Get(nueva_pelicula.Nota);
	 	Skip_Line;
	 	
	 	array_peliculas(i) := nueva_pelicula;
 	 end loop;
 	 
 	 
 	 
 	 -- Mostrar por pantalla los valores del array
 	 -- Inicializamos con el primer valor del array que hemos indicado que es 1 en la declaracion
 	 pelicula_minima := array_peliculas(1);
 	 pelicula_maxima := array_peliculas(1);
 	 primera_pelicula := array_peliculas(1);
 	 ultima_pelicula := array_peliculas(1);
 	 
 	 Put_Line("Numero de registros:" & n_registros'Image);
 	 
 	 for i in 1..n_registros loop
 	 	Put_Line("Registro nro." & i'Image);
 	 	Put_Line("Titulo:" & array_peliculas(i).Titulo);
 	 	Put_Line("Fecha. Dia:" & array_peliculas(i).Fecha.Dia'Image);
 	 	Put_Line("Fecha. Mes: " & array_peliculas(i).Fecha.Mes'Image);
 	 	Put_Line("Fecha. Anno:" & array_peliculas(i).Fecha.Anno'Image);
 	 	Put_Line("Nota:" & array_peliculas(i).Nota'Image);
 	 	New_Line;
 	 	
 	 	notas := notas + float(array_peliculas(i).Nota);
 	 	
 	 	-- Obtener la minima pelicula
 	 	if pelicula_minima.Nota >= array_peliculas(i).Nota then
 	 		pelicula_minima := array_peliculas(i);
 	 	end if;
 	 	
 	 	-- Obtener la maxima pelicula
 	 	if pelicula_maxima.Nota <= array_peliculas(i).Nota then
 	 		pelicula_maxima := array_peliculas(i);
 	 	end if;
 	 	
 	 	-- Obtener la primera pelicula
 	 	if primera_pelicula.Fecha.Anno >= array_peliculas(i).Fecha.Anno then
 	 		if mes_t'Pos(primera_pelicula.Fecha.Mes) >= mes_t'Pos(array_peliculas(i).Fecha.Mes) then
 	 			if primera_pelicula.Fecha.Dia >= array_peliculas(i).Fecha.Dia then
 	 				primera_pelicula := array_peliculas(i);
 	 			end if;
 	 		end if;
 	 	end if;
 	 	
 	 	-- Obtener la ultima pelicula
 	 	if ultima_pelicula.Fecha.Anno <= array_peliculas(i).Fecha.Anno then
 	 		if mes_t'Pos(ultima_pelicula.Fecha.Mes) <= mes_t'Pos(array_peliculas(i).Fecha.Mes) then
 	 			if ultima_pelicula.Fecha.Dia <= array_peliculas(i).Fecha.Dia then
 	 				ultima_pelicula := array_peliculas(i);
 	 			end if;
 	 		end if;
 	 	end if;
 	 	
 	 end loop;
 	 
 	 nota_media := notas/Float(n_registros);
 	 
 	 Put("Nota minima:" & pelicula_minima.Nota'Image);
 	 New_Line;
 	 Put("Pelicula: " & pelicula_minima.Titulo);
 	 Put(" alquilada el" & pelicula_minima.Fecha.Dia'Image);
 	 Put(" de " & pelicula_minima.Fecha.Mes'Image);
 	 Put(" de " & pelicula_minima.Fecha.Anno'Image);
 	 New_Line;
 	 
 	 Put("Nota maxima: " & pelicula_maxima.Nota'Image);
 	 New_Line;
 	 Put("Pelicula: " & pelicula_maxima.Titulo);
 	 Put(" alquilada el" & pelicula_maxima.Fecha.Dia'Image);
 	 Put(" de " & pelicula_maxima.Fecha.Mes'Image);
 	 Put(" de " & pelicula_maxima.Fecha.Anno'Image);
 	 New_Line;
 	 
 	 Put("Nota media del periodo" & primera_pelicula.Fecha.Dia'Image);
 	 New_Line;
 	 Put(" de " & primera_pelicula.Fecha.Mes'Image);
 	 Put(" de " & primera_pelicula.Fecha.Anno'Image);
 	 Put(" al " & ultima_pelicula.Fecha.Dia'Image);
 	 Put(" de " & ultima_pelicula.Fecha.Mes'Image);
 	 Put(" de " & ultima_pelicula.Fecha.Anno'Image);
 	 Put(" ha sido de ");
 	 Float_ES.Put(nota_media, Aft => 2, Exp => 0); --Para mostrar solo 2 decimales del resultado
 	 New_Line;
 	 
end registros;
