with Ada.Text_IO; use Ada.Text_IO;

package body PID is

	package Real_ES is new Ada.Text_IO.Float_IO(Real);

   	-- Procedimiento Programar
	procedure Programar (el_Controlador: in out Controlador; Kp, Ki, Kd: Real) is
	  begin
	    -- Asignar al controlador las constantes
	    el_Controlador.Kp := Kp;
	    el_Controlador.Ki := Ki;
	    el_Controlador.Kd := Kd;
	end Programar;
	                     
	procedure Controlar(con_el_Controlador: in out Controlador; R,C:Entrada; U:out Salida) is
	    error_actual, proporcional, integral, derivada, U_Float: Real;
	    
	  begin
	    -- Error = Referencia - Actual
	    error_actual := Real(R) - Real(C);
	    con_el_Controlador.S_Anterior := con_el_Controlador.S_Anterior + error_actual;
	    
	    -- Parte proporcional (error_actual)
	    proporcional := error_actual;
	    
	    -- Parte integral (error_acumulado * const)
	    integral := con_el_Controlador.S_Anterior * con_el_Controlador.Ki;

	    -- Parte derivada (error_actual - error_anterior) * const
	    derivada := (error_actual - con_el_Controlador.Error_Anterior) * con_el_Controlador.Kd;
	    
	    U_Float := con_el_Controlador.Kp * (proporcional + integral + derivada);
	    
	    --New_Line;
	    --Put("U = ");
	    --Real_ES.Put(U_Float, Fore => 4, Exp => 0, Aft => 2);
	    --New_Line;
	    
	    if U_Float < 0.0 then
	    	U_Float := 0.0; 
	    end if;
	    
	    U := Salida(U_Float);
	    
	    con_el_Controlador.Error_Anterior := error_actual;
	    
	end Controlar;
	
end PID;
