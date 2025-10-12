with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Sensor; use Sensor;
with Calefactor; use Calefactor;

procedure Medir2 is
   	--Declaracion de Paquetes
	package Real_Es is new Ada.Text_Io.Float_Io(Float);
	   
	T_Inicial, T_Final: Time;
	T_Actual, T_Anterior: Temperaturas;
	Ct, Delta_Temperatura, Delta_Tiempo: Float;
	Potencia_Medicion: Potencias := 1000.0;
	Numerador : Float;
	   
	-- Coeficientes Obtenidos en el medir1
	Te : Temperaturas := 20.00 ;
	Cp : Float;	

begin
	Put ("Introduce el valor de Cp en medir1: ");
   	Real_Es.Get(Cp);	
	
	-- Excitar y medir
	T_Inicial := Clock;
	Calefactor.Escribir(Potencia_Medicion);

	loop -- Esperar hasta que la temperatura cambie desde Te
	 	Sensor.Leer(T_Actual);
	      	exit when abs(Float(T_Actual - Te)) > 0.01;
	end loop;

	T_Anterior := T_Actual;
	delay 5.0;  -- Esperar 5 segundos para medir el cambio

   	T_Final := Clock;
   	Sensor.Leer(T_Actual);

	Delta_Temperatura := Float(T_Actual - T_Anterior);
   	Delta_Tiempo := Float(To_Duration(T_Final - T_Inicial));

   	-- Mostrar valores
   	Put("T_anterior: ");
   	Real_Es.Put(Float(T_Anterior), Fore => 0, Aft => 2, Exp => 0);
   	New_Line;
   
   	Put("T_actual: ");
   	Real_Es.Put(Float(T_Actual), Fore => 0, Aft => 2, Exp => 0);
   	New_Line;
   
   	Put("Delta_Temperatura: ");
   	Real_Es.Put(Delta_Temperatura, Fore => 0, Aft => 4, Exp => 0);
   	New_Line;
   
   	Put("Delta_Tiempo: ");
   	Real_Es.Put(Delta_Tiempo, Fore => 0, Aft => 4, Exp => 0);
   	New_Line;
 
   	-- Calcular Ct
   	Numerador := (Float(Potencia_Medicion) - (Cp * (Float(T_Actual - Te)))) * Delta_Tiempo;
   	Ct := Numerador / Delta_Temperatura;
   
   	Put("Ct: ");
   	Real_Es.Put(Ct, Fore => 0, Aft => 2, Exp => 0);
   	New_Line;

   	Calefactor.Escribir(0.0); --Volver a poner potencias a 0 porque hemos terminado

end Medir2;

