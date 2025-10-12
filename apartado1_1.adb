with Ada.Text_Io, Plan, Proc;
use Ada.Text_Io, Plan, Proc;

procedure Apartado1_1 is
   	Tareas : array_reg_Planificacion_t := (
	      (1, 2400, 600, 3, 1, 0, False),   -- Tarea 1
	      (2, 3200, 1200, 3, 2, 0, False),  -- Tarea 2
	      (3, 3600, 2000, 3, 3, 0, False),  -- Tarea 3
	      (4, 4000, 3200, 4, 4, 0, False)   -- Tarea 4
   	);
   	
	Procedimientos : array_ref_Procedimiento_t := (P1'Access, P2'Access, P3'Access, P4'Access);
	
	Tiempos : array_Tiempos_t(Procedimientos'Range);
begin
	
	Plan.Medir(Procedimientos, Tiempos, Tareas);
	
end Apartado1_1;
