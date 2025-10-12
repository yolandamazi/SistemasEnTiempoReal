with Proc; use Proc;

package Plan is

	-- Declaracion de Tipos
	type ref_Procedimiento_t is access procedure;
	type reg_Planificacion_t is record
		Nombre : Positive; -- Número de la tarea
		T : Natural; -- Período
		D : Natural; -- Plazo
		C : Natural; -- Tiempo de cómputo
		P : Positive; -- Prioridad
		R : Natural; -- Tiempo de respuesta
		Planificable: Boolean;
	end record;
		
	type array_ref_Procedimiento_t is array (Positive range <>) of ref_Procedimiento_t;
	type array_reg_Planificacion_t is array (Positive range <>) of reg_Planificacion_t;
	type array_Tiempos_t is array (Positive range <>) of Natural;
	
	-- Procedimientos
	procedure Medir (Procedimientos: array_ref_Procedimiento_t; Tiempos : out array_Tiempos_t);
	
	procedure Planificar (Tareas: in out array_reg_Planificacion_t);
	procedure Medir (Procedimientos: array_ref_Procedimiento_t; Tiempos : out array_Tiempos_t; Tareas: in out array_reg_Planificacion_t);
	
	-- Funciones
	function tiempoRespuesta (Tareas: array_reg_Planificacion_t; T: reg_Planificacion_t) return Natural;
	
end Plan;
