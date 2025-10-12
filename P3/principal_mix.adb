with Ada.Text_Io; use Ada.Text_Io;
with Fracciones; use Fracciones;
with Colas;

procedure Principal_mix is
	package Colas_de_Fraccion is new Colas (fraccion_t, Imprimir);
	use Colas_de_Fraccion;

	colaFraccion : cola_t;
	nuevaFraccion : fraccion_t;
begin
	
	for i in 1..4 loop
		for j in 1..4 loop
			nuevaFraccion := i/j;
			Colas_de_Fraccion.Poner(nuevaFraccion, colaFraccion);
		end loop;
	end loop;
	Put_Line("En la cola de fracciones tenemos...");
	Colas_de_Fraccion.MostrarCola(colaFraccion); --En la salida se muestran valores irreducibles por lo que fracciones como 4/4 salen como 1/1, 4/2, sale como 2/1, etc,...
	
end Principal_mix;

