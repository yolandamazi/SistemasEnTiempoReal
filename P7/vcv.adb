with Ada.Text_IO;       use Ada.Text_IO;
with GNAT.Sockets;      use GNAT.Sockets;
with Ada.Calendar;      use Ada.Calendar;
with Ada.Streams;
with Ada.Strings.Unbounded;
with Ada.Numerics.Elementary_Functions;
with Ada.Float_Text_Io; use Ada.Float_Text_Io;

use type Ada.Streams.Stream_Element_Count;
use Ada.Numerics.Elementary_Functions;

with Ada.Text_Io, Ada.Real_Time;

procedure Vcv is

   package Ent_ES is new Integer_IO (Integer);

   Client  : Socket_Type;
   Address : Sock_Addr_Type;
   Channel : Stream_Access;

   Send   : String :=
     (1 => ASCII.CR, 2 => ASCII.LF, 3 => ASCII.CR, 4 => ASCII.LF);
   Offset : Ada.Streams.Stream_Element_Count;
   Data   : Ada.Streams.Stream_Element_Array (1 .. 1);

   RetMsg : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;

   ControlMsg : Ada.Strings.Unbounded.Unbounded_String :=
     Ada.Strings.Unbounded.Null_Unbounded_String;

   type err_ang_t is digits 3 range -3.15 .. 3.15;
   type err_lat_t is digits 4 range -99.99 .. 99.99;
   type velocidad_t is digits 5 range 0.00 .. 500.00;
   type distancia_t is digits 6 range -9999.00 .. 9999.0;
   type volante_t is digits 3 range -1.0 .. 1.0;
   type accFreno_t is digits 3 range -1.0 .. 1.0;
   type radio_t is digits 7 range 0.0 .. 99999.99;
   
   ------------------------------------------------
   
   package controlCurvatura is new PID (Real => Float, Entrada => err_lat_t,   Salida => volante_t);
   package controlVelocidad is new PID (Real => Float, Entrada => velocidad_t, Salida => velocidad_t);
   
   -- valores previamente dados
   
   controlCurvatura : controlCurvatura.Controlador;
   kpCurvatura : constant Float := 0.02; 
   kiCurvatura : constant Float :=  0.0;
   kdCurvatura : constant Float := 0.01;
    
   controlVelocidad : controlVelocidad.Controlador;
   kpVelocidad : constant Float := 0.2;
   kiVelocidad : constant Float :=  0.0;
   kdVelocidad : constant Float := 0.1;
   
   velDeseada : velocidad_t;
   
   -------------------------------------------------

   c : Character;

   j     : Integer := 1;
   count : Integer := 0;

   Kp, Ki, Kd : Float;

   us : Float;

   D_err_lat : err_lat_t;

   Err_ang                                : err_ang_t;
   Err_lat, Err_lat_ant                   : err_lat_t;
   Curvatura, CurvaturaSig, Tipo, TipoSig : Float;

   velocidad     : velocidad_t;
   dist, distSig : distancia_t;
   refVelocidad  : velocidad_t;

   volante   : volante_t;
   acelFreno : accFreno_t;

   y, cx, sx, ang, fang : Float;

begin

   ------------------------------------------------------------
   
   controlCurvatura.Programar(controlCurvatura,kp_curv,ki_curv,kd_curv);
   controlVelocidad.Programar(controlVelocidad,kp_vel,ki_vel,kd_vel);
   
   ------------------------------------------------------------

   GNAT.Sockets.Initialize;  -- initialize a specific package
   Create_Socket (Client);
   Address.Addr := Inet_Addr ("127.0.0.1");
   Address.Port := 12321;

   Connect_Socket (Client, Address);
   Channel := Stream (Client);

   -- Esta es la cadena de configuración. Cambiar los números para los distintos modos
   String'Write (Channel, "Controller init request 32" & Send);

   Curvatura := 0.0;
   CurvaturaSig := 1.0;
   distSig := 0.0;
   velocidad := 0.0;

   while Curvatura /= 0.0
     or CurvaturaSig /= 0.0
     or distSig /= 0.0
     or velocidad /= 0.0
   loop

      count := 0;
      ControlMsg := Ada.Strings.Unbounded.Null_Unbounded_String;
      RetMsg := Ada.Strings.Unbounded.Null_Unbounded_String;

      loop
         Ada.Streams.Read (Channel.all, Data, Offset);
         Ada.Strings.Unbounded.Append
           (Source => RetMsg, New_Item => Character'Val (Data (1)));
         exit when Character'Val (Data (1)) = '*';
      end loop;

      ---- Lectura de los datos que manda el coche
      Ada.Text_IO.Put_Line (Ada.Strings.Unbounded.To_String (RetMsg));

      j := 1;

      for i in Ada.Strings.Unbounded.To_String (RetMsg)'Range loop
         c := Ada.Strings.Unbounded.To_String (RetMsg) (i);

         if (c = ';' or c = '*') then
            count := count + 1;

            case count is
               when 1 =>
                  Err_ang :=
                    err_ang_t'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 2 =>
                  Err_lat :=
                    err_lat_t'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 3 =>
                  Tipo :=
                    Float'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 4 =>
                  Curvatura :=
                    Float'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 5 =>
                  dist :=
                    distancia_t'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 6 =>
                  TipoSig :=
                    Float'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 7 =>
                  CurvaturaSig :=
                    Float'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 8 =>
                  distSig :=
                    distancia_t'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when 9 =>
                  velocidad :=
                    velocidad_t'Value
                      (Ada.Strings.Unbounded.To_String (RetMsg) (j .. i - 1));

               when others =>
                  null;
            end case;

            j := i + 1;
         end if;
      end loop;

      -- Sacamos por pantalla lo que manda el coche
      Ada.Text_IO.Put_Line
        ("You gave me "
         & err_ang_t'image (Err_ang)
         & " "
         & err_lat_t'image (Err_lat)
         & " "
         & Float'image (Tipo)
         & " "
         & Float'image (Curvatura)
         & " "
         & distancia_t'image (dist)
         & " "
         & Float'image (TipoSig)
         & " "
         & Float'image (CurvaturaSig)
         & " "
         & distancia_t'image (distSig)
         & " "
         & velocidad_t'image (velocidad));

      -- Aqui va vuestro código de control. Con los datos leídos tenéis que escribir en volante y refVelocidad vuestros comandos. Esto es un ejemplo
      volante := 0.0;   -- Volante al centro (para modo lateral 3)
      refVelocidad := 10.0;  -- Velocidad 10m/s (para modo longitudinal 2)
      --------------------------------------------------------------------------------------------------------------------------
      
      
      
      -- Si el siguiente no es recto y está cerca, o el actual no es recto
      if (TipoSig /= 3.0 and dist < distancia_t(30)) or Tipo /= 3.0 then
	   -- Usamos la curvatura actual, pero si no hay usamos el de la siguiente parte
	   if Curvatura /= 0.0 then
	      curv := abs(Curvatura);  
	   else
	      curv := abs(CurvaturaSig);  
	   end if;
	   --Usamos la formula que relaciona la curvatura con la velocidad
	   --0.85 es el coef de friccion general
	   --9.81 el valor de la gravedad
	   -- velocidad = raiz cuadrada (friccion * gravedad * curvatura)
	   refVelocidad := velocidad_t(Sqrt(0.85*9.81*curv));
	   
	else
	   -- Si estamos en una recta, ponemos velocidad máxima
	   refVelocidad := velocidad_t(120.0);
	end if;

	controlCurvatura.Controlar(controlCurvatura, Err_lat, 0.0, volante);

	-- Corrección según el error lateral
	if abs(Err_lat) > 1.2 then  
	   -- Si el error lateral es grande, corregimos solo ese
	   volante := volante_t(Err_lat / 12.0); --Entre 12 porque el error con una correccion de 0.1 implica 12 o mas
	else  
	   -- Si el error lateral es pequeno, corregimos solo el angular
	   volante := volante_t(Err_ang / 1.2)
	end if;

	controlVelocidad.Controlar(controlVelocidad, velocidad, refVelocidad, refVelocidad);

      
      
      
--------------------------------------------------------------------------------------------------------------------------

      --- Se envían los comandos al coche
      Ada.Strings.Unbounded.Append
        (Source => ControlMsg, New_Item => volante_t'image (volante));
      Ada.Strings.Unbounded.Append (Source => ControlMsg, New_Item => ';');
      Ada.Strings.Unbounded.Append
        (Source => ControlMsg, New_Item => velocidad_t'image (refVelocidad));
      Ada.Strings.Unbounded.Append (Source => ControlMsg, New_Item => '*');

      String'Write
        (Channel, Ada.Strings.Unbounded.To_String (ControlMsg) & Send);

   end loop;
   --

   --- Comando para terminar la carrera

   String'Write (Channel, "Controller end request 44" & Send);

end Vcv;
