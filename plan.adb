with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Ada.Calendar; use Ada.Calendar;
with Proc;

package body Plan is

	-- Procedimiento Medir
   	procedure Medir (Procedimientos: array_ref_Procedimiento_t; Tiempos : out array_Tiempos_t) is
   		-- Declaracion de variables
      		tInicio, tFin : Ada.Real_Time.Time;
      		tTranscurrido : Ada.Real_Time.Time_Span;
    	  begin
    	  
      		for i in Procedimientos'Range loop
   	  		-- Comenzamos a medir
      	  		tInicio := Ada.Real_Time.Clock;
      	  		-- Ejecutamos el procedimiento
      	  		Procedimientos(i).all;
      	  		-- Medimos cuando termina de ejecutarse
    	  		tFin := Ada.Real_Time.Clock;
    	  		tTranscurrido := tFin - tInicio;
     	  		Tiempos(i) := Integer(To_Duration(tTranscurrido) * 1000.0);
      		end loop;
   	end Medir;

	-- Procedimiento Planificar
	procedure Planificar (Tareas: in out array_reg_Planificacion_t) is 
		-- Declaracion de variables
		W, W0 : Natural;
	  begin
	  	-- Asignar prioridad
	  	for j in Tareas'Range loop
	  		for i in Tareas'Range loop
	  			if Tareas(i).D < Tareas(j).D then
	  				Tareas(i).P := Tareas(i).P + 1;	
	  			end if;
	  		end loop;
	  	end loop;
	  	
	  	-- Calcular tiempo de respuesta
	  	for i in Tareas'Range loop
	  		-- Calcular primera W
	  		W0 := Tareas(i).C;
	  		for j in Tareas'Range loop
         			if Tareas(j).P > Tareas(i).P then
            				W0 := W0 + Tareas(j).C;
         			end if;
      			end loop;
      			
      			Tareas(i).R := W0;
	  		W := tiempoRespuesta (Tareas, Tareas(i));
 
	  		while (W /= Tareas(i).R) loop
	  			Tareas(i).R := W;
	  			W := tiempoRespuesta (Tareas, Tareas(i));
	  		end loop;
	  		
	  	end loop;
	  	
	  	-- Calcular Planificabilidad
	  	for i in Tareas'Range loop
	  		if (Tareas(i).R <= Tareas(i).D) then 
				Tareas(i).Planificable := True;
	  		end if;	
	  	end loop;
	  		
	end Planificar;
	
	-- Funcion T. de Respuesta
	function tiempoRespuesta (Tareas: array_reg_Planificacion_t; T: reg_Planificacion_t) return Natural is
      		Suma : Natural := 0;
   	  begin
      		for i in Tareas'Range loop
         		if Tareas(i).P > T.P then
            			Suma := Suma + Natural(Float'Ceiling(Float(T.R)/Float(Tareas(i).T))) * Tareas(i).C;
         		end if;
      		end loop;
       	return T.C + Suma;
   	end tiempoRespuesta;
	
	-- Procedimiento Medir usando Medir y Planificar previos
	procedure Medir (Procedimientos: array_ref_Procedimiento_t; Tiempos : out array_Tiempos_t; Tareas: in out array_reg_Planificacion_t) is
	
		package Integer_Es is new Integer_Io (Integer); use Integer_Es;
		
	  begin
		Medir(Procedimientos, Tiempos);
		
		Put_line (
			"+------------------------------+");
		Put_Line (
			"|  Procedimiento    T.Computo  |");
		Put_line (
			"|------------------------------|");
		for i in Tiempos'Range loop
			Put ("|       ");
			Put (Integer'Image(i));
			Put ("             ");
			Put (Integer'Image(Tiempos(i)));
			Put_Line (" ");
		end loop;
		Put_line ("+------------------------------+");
		
		-- Asignar tiempos de computo e inicializar prioridades a 1
		for i in Tiempos'Range loop
			Tareas(i).C := Tiempos(i);
			Tareas(i).P := 1;
		end loop;
		
		Planificar(Tareas);
		Put_line (
		"+---------------------------------------------------+");
		Put_Line (
		"|   Tarea   T    D    C     P    R   Planificable   |");
		Put_line (
		"|---------------------------------------------------|");
		for I in Tareas'Range loop
			Put ("| ");
			Put (Tareas(I).Nombre, Width=>5); Put (" ");
			Put (Tareas(I).T, Width=>6); Put (" ");
			Put (Tareas(I).D, Width=>4); Put (" ");
			Put (Tareas(I).C, Width=>4); Put (" ");
			Put (Tareas(I).P, Width=>4); Put (" ");
			Put (Tareas(I).R, Width=>4); Put (" ");
			if Tareas(I).Planificable then
				Put_Line ("  SI    |");
			else
				Put_Line ("  NO    |");
			end if;
		end loop;
		Put_line (
		"+---------------------------------------------------+");
	end Medir;
	
end Plan;
