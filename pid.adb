package body PID is
   procedure Programar
     (el_Controlador : in out Controlador; Kp : Real; Ki : Real; Kd : Real) is
   begin
      el_Controlador :=
        (Kp             => Kp,
         Ki             => Ki,
         Kd             => Kd,
         S_Anterior     => 0.0,
         Error_Anterior => 0.0);
   end Programar;
   procedure Controlar
     (con_el_Controlador : in out Controlador; R, C : Entrada; U : out Salida)
   is
      Cont       : Controlador renames con_el_Controlador;
      E          : Real;
      S          : Real;
      Up, Ui, Ud : Real;
   begin
      -- Calculos de control
      E := Real (R - C);
      -- kp.e(n)
      Up := Cont.Kp * E;
      -- s(n) = s(n-1) + e(n)
      S := Real (Cont.S_Anterior) + E;
      -- ki.s(n)
      Ui := Real (Cont.Ki) * S;
      -- kd.[e(n)-e(n-1)]
      Ud := Real (Cont.Kd) * (E - Real (Cont.Error_Anterior));
      U := Salida (Up + Ui + Ud);

      -- Actualizacion del estado
      Cont.S_Anterior := S;
      Cont.Error_Anterior := E;
   end Controlar;
end PID;
