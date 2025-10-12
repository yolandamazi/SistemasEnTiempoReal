with Ada.Text_Io, Plan;
use Ada.Text_Io, Plan;
procedure Prueba is
	package Integer_Es is new Integer_Io (Integer); use Integer_Es;
	Tareas: array_reg_Planificacion_t := (( 1, 20, 20, 3, 1, 0, False ),
						( 2, 20, 5, 3, 1, 0, False ),
						( 3, 15, 7, 3, 1, 0, False ),
						( 4, 10, 10, 4, 1, 0, False ));
begin
	Planificar (Tareas);
	Put_line (
	"+---------------------------------------------------+");
	Put_Line (
	"|   Tarea   T   D    C    P    R   Planificable |");
	Put_line (
	"|---------------------------------------------------|");
	for I in Tareas'Range loop
		Put ("| ");
		Put (Tareas(I).Nombre, Width=>5); Put (" ");
		Put (Tareas(I).T, Width=>4); Put (" ");
		Put (Tareas(I).D, Width=>4); Put (" ");
		Put (Tareas(I).C, Width=>4); Put (" ");
		Put (Tareas(I).P, Width=>4); Put (" ");
		Put (Tareas(I).R, Width=>4); Put (" ");
		if Tareas(I).Planificable then
			Put_Line (" SI |");
		else
			Put_Line (" NO |");
		end if;
	end loop;
	Put_line (
	"+---------------------------------------------------+");
end Prueba;

