with Ada.Real_Time;
use  Ada.Real_Time;
package body Proc is
   C1: constant := 400;
   C2: constant := 600;
   C3: constant := 800;
   C4: constant := 800;

   procedure Retardar (Retardo: Natural) is
      T1: Time;
   begin
      T1 := Clock;
      -- Bucle con espera activa que simula un
      -- cómputo
      while Clock-T1 < Milliseconds(Retardo) loop
         null;
      end loop;
   end Retardar;

   procedure P1 is begin
      Retardar (C1);
   end P1;

   procedure P2 is begin
      Retardar (C2);
   end P2;

   procedure P3 is begin
      Retardar (C3);
   end P3;

   procedure P4 is begin
      Retardar (C4);
   end P4;

end Proc;