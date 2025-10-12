with Ada.Text_IO; use Ada.Text_IO;
with Horno; use Horno;

package body Sensor is
   procedure Leer (la_Temperatura: out Temperaturas) is 
   begin
   	Horno.Leer(Horno.Temperaturas(la_Temperatura));
   end Leer;
   
end Sensor;
