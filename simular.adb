with Ada.Text_Io, Ada.Real_Time, Plan, Proc;
use Ada.Text_Io, Ada.Real_Time, Plan, Proc;

procedure Simular is
	
	type ref_Procedimiento_t is access procedure;
	
	task type Tarea_t (
		Nombre : Natural;
		T : Natural;
		D : Natural;
		C : Natural;
		P : Natural;
		Codigo_Ciclico: ref_Procedimiento_t) 
	is pragma Priority (P);
	end Tarea_t;
	
	task body Tarea_t is
		tInicial, tFinal : Time;
        	tTranscurrido : Time_Span;
        	proxActivacion : Time := Clock;
        	primeraActivacion : Time := Clock;
	begin
		loop
			if To_Duration(Clock - primeraActivacion) >= 50.0 then
            			Put_Line("Fin de la simulación.");
            			exit; -- Salimos
        		end if;
		
			delay until proxActivacion;
			
			tInicial := Clock;
			Codigo_Ciclico.all;	-- Ejecutamos
			tFinal := Clock;
			tTranscurrido := tFinal - tInicial;
			
			if Integer(To_Duration(tTranscurrido) * 1000.0) > Integer(D) then
		        	Put_Line("Tarea " & Nombre'Image & " ha superado su deadline");
		    	end if;
		    	
		    	proxActivacion := proxActivacion + Milliseconds(T);
		    	
		    	Put_Line("Tarea " & Nombre'Image & " se volvera a activar en " & Integer'Image(Integer(To_Duration(proxActivacion - Clock))) & " segundos");
		    	
		    	Put_Line("Llevamos " & Integer'Image(Integer(To_Duration(Clock - primeraActivacion))) & " segundos de activacion");
		    	
		end loop;
	end Tarea_t;
	
	Tarea1 : Tarea_t (1, 2400, 600, 400, 4, P1'Access);
	Tarea2 : Tarea_t (2, 3200, 1200, 600, 3, P2'Access);
	Tarea3 : Tarea_t (3, 3600, 2000, 800, 2, P3'Access);
	Tarea4 : Tarea_t (4, 4000, 3200, 800, 1, P4'Access);

	duracion : constant duration := 50.0;
				
begin

	delay Duration(duracion);
	Put_Line("Fin de la simulación.");
	
end Simular;
