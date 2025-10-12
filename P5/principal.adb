with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with PID; 
with Sensor; use Sensor;
with Calefactor; use Calefactor;

procedure principal is
	  -- Declaracion de paquetes
	  package Float_ES is new Ada.Text_Io.Float_Io(Float);
	  package Real_ES is new Ada.Text_IO.Float_IO(Float);
	  package Temperaturas_ES is new Ada.Text_Io.Float_Io(Temperaturas);
	  package PID_Float is new PID (Real => Float, Entrada => Float, Salida => Float);
	  
	  -- Declaracion de variables
	  duracion : Duration := 10.0 * 60.0; -- 10 min en seg
	  tiempoActual, tiempoInicial, tiempoFinal : Time;
	  controladorPID : PID_Float.Controlador;
	  temperaturaReferencia : Float;
	  temperaturaActual : Temperaturas;
	  P : Float;
	
	begin
	  --Probamos valores de constantes en base a los resultados obtenidos en el apartado 1
	  --PID_Float.Programar(controladorPID, Kp => 2.0*0.0115, Ki => 2.0*3.3999, Kd => 2.0*0.85);
	  PID_Float.Programar(controladorPID, Kp => 0.02, Ki => 6.6, Kd => 1.7);
	  
	  --Cuando pasen 10 minutos desde el instante actual
	  tiempoInicial := Clock;
	  tiempoActual := Clock;
   	  tiempoFinal := tiempoActual + Seconds(Integer(duracion));
	   	
	  Put("Introduce la Temperatura:");
	  Float_ES.Get(temperaturaReferencia); 	
	  
	  loop 	  
	      -- Cada 500 milisegundos
	      delay until (tiempoActual + Milliseconds(500));
	      
	      -- Leer temperatura del sensor
	      Sensor.Leer(temperaturaActual);
	      
	      -- Calcular error y calcular PID(e)
	      PID_float.Controlar(controladorPID, temperaturaReferencia, Float(temperaturaActual), P);
	      
	      -- Escribir P en el calefactor 
	      Calefactor.Escribir(Potencias(P));
	      --Put("Potencia aplicada: ");
	      --Float_ES.Put(P, Aft => 2, Exp => 0);
	      --New_Line;
	      
	      -- Escribir T en pantalla
	      --Put("Temperatura actual: ");
	      --Temperaturas_ES.Put(temperaturaActual, Exp => 0, Aft => 2);
	      --New_Line;
	      
	      tiempoActual := Clock;
	      
	      --Put("Tiempo Transcurrido: ");
   	      --Real_Es.Put(Float(To_Duration(tiempoActual - tiempoInicial)) / 60.0, Fore => 0, Aft => 2, Exp => 0); New_Line;
   	      
   	      -- Ordenamos para copiar y pegar datos posteriorimente en txt y crear grafica
   	      -- Formato: tiempo, temperatura, potencia
   	      Put("DATOS: ");
   	      Float_ES.Put(Float(To_Duration(tiempoActual - tiempoInicial)) / 60.0, Aft => 2, Exp => 0);
   	      Put(", ");
   	      Float_ES.Put(Float(temperaturaActual), Aft => 2, Exp => 0);
   	      Put(", ");
   	      Float_ES.Put(P, Aft => 2, Exp => 0);
   	      New_Line;
   	
	      exit when tiempoActual >= tiempoFinal;
	   end loop;
	
end principal;
