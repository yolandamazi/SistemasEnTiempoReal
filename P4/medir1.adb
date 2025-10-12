with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Sensor; use Sensor;
with Calefactor; use Calefactor;

procedure Medir1 is
	--Declaracion de paquetes
	package Real_Es is new Ada.Text_Io.Float_Io(Float);
	
	T_Inicial, T_Final: Time;
   	Te, T_Actual: Temperaturas;
   	L: Time_Span;
   	Cp: Float;
   	Potencia_Medicion: Potencias := 1000.0;

begin
	-- Medir Te
	Sensor.Leer(Te);
	Put("Temperatura en reposo (Te): ");
	Real_Es.Put(Float(Te), Fore => 0, Aft => 2, Exp => 0);
	New_Line;
	
	-- Medir L 
	T_Inicial := Clock;
	Calefactor.Escribir(Potencia_Medicion);
	
	loop -- Esperar hasta que la temperatura cambie minimo una centesima
	   	Sensor.Leer(T_Actual);
	      	exit when abs(Float(T_Actual - Te)) > 0.01;  -- Detecta el cambio minimo
	end loop;
	
	delay 5.0; -- Esperar 5 segundos para medir el cambio
	
	T_Final := Clock;
	L := T_Final - T_Inicial;
	Put("Tiempo de respuesta (L): ");
	Real_Es.Put(Float(To_Duration(L)), Fore => 0, Aft => 2, Exp => 0);
	New_Line;
	
   	-- Calcular Cp
   	Sensor.Leer(T_Actual);
      	Cp := Float(Potencia_Medicion) / Float(T_Actual - Te);
   	Put("Coeficiente de pérdidas térmicas (Cp): ");
   	Real_Es.Put(Float(Cp), Fore => 0, Aft => 2, Exp => 0);
   
   	Calefactor.Escribir(0.0); --Volver a poner potencias a 0 porque hemos terminado
   	
end Medir1;
