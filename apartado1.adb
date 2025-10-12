with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;
with Calefactor; use Calefactor;
with Sensor; use Sensor;

procedure Apartado1 is

   package Temperaturas_ES is new Ada.Text_IO.Float_IO(Temperaturas);
   package Potencias_ES is new Ada.Text_IO.Float_IO(Potencias);
   package Real_ES is new Ada.Text_IO.Float_IO(Float);

   -- Variables de tiempo y temperatura
   T_Inicial, T_L, T_Final : Time;
   Potencia                : Potencias := 1000.0;
   Temp_Inicial, Temp_Final, Temp_Actual : Temperaturas;
   K, L, tau               : Float;
   Kp, Ti, Td              : Float;

   -- Flags
   contL : Boolean := False;

begin
   -- Leer temperatura inicial
   Sensor.Leer(Temp_Inicial);
   Put("Temperatura en reposo: ");
   Real_ES.Put(Float(Temp_Inicial), Fore => 0, Aft => 2, Exp => 0);
   New_Line;

   -- Escribir potencia
   Calefactor.Escribir(Potencia);
   T_Inicial := Clock;

   -- Esperar a que comience a cambiar la temperatura (para estimar L)
   Temp_Final := Temp_Inicial;
   loop
      Sensor.Leer(Temp_Actual);

      if not contL and then abs(Float(Temp_Actual - Temp_Inicial)) > 0.1 then
         T_L := Clock;
         contL := True;
      end if;

      -- Termina cuando se estabiliza (opcionalmente ajustable)
      if contL and then abs(Float(Temp_Actual - Temp_Final)) < 0.1 then
         exit;
      end if;

      Temp_Final := Temp_Actual;
   end loop;

   T_Final := Clock;

   -- Cálculos de parámetros de planta
   L := Float(To_Duration(T_L - T_Inicial));  -- Tiempo muerto
   tau := Float(To_Duration(T_Final - T_L));  -- Tiempo de subida
   K := Float(Temp_Final - Temp_Inicial) / Float(potencia);  -- Ganancia del sistema

   -- Cálculo PID con Ziegler-Nichols (método de la respuesta escalón)
   Kp := 1.2 * (tau / (K * L));
   Ti := 2.0 * L;
   Td := 0.5 * L;

   -- Mostrar resultados
   New_Line;
   Put_Line("Constantes PID calculadas");
   Put("Kp = "); Real_ES.Put(Kp, Fore => 0, Aft => 4, Exp => 0);
   New_Line;
   Put("Ti = "); Real_ES.Put(Ti, Fore => 0, Aft => 4, Exp => 0);
   New_Line;
   Put("Td = "); Real_ES.Put(Td, Fore => 0, Aft => 4, Exp => 0);
   New_Line;
   Put("Temperatura Final = "); Real_ES.Put(Float(Temp_Final), Fore => 0, Aft => 4, Exp => 0);
   New_Line;

end Apartado1;

