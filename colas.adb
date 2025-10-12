																																						with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation; 

package body Colas is

	-- Liberar usando deallocation 
	procedure Liberar (cola : in out cola_t) is
		-- Declarar dentro de Liberar porque es un procedimiento que pertenece unicamenete a Liberar y no al paquete generico colas en general
		procedure Free is new Ada.Unchecked_Deallocation(Nodo, ref_Nodo);
		n : ref_Nodo := cola.Ptr_Primero;
	begin
		Free(n);
		if n = null then
			Ada.Text_IO.Put_Line("Memory deallocated successfully.");
		end if;
	end Liberar;
	
	-- Anadir nodo a la cola
	procedure Poner (el_Elemento: elemento_t; en_la_Cola: in out cola_t) is
		-- Creamos un nodo nuevo
		nuevoNodo: ref_Nodo := new Nodo'(Datos => el_Elemento, Ptr_Siguiente => null); 
	begin
		-- Si la cola no tiene primer elemento el nuevo nodo lo sera
		if en_la_Cola.Ptr_Primero = null then
         		en_la_Cola.Ptr_Primero := nuevoNodo;
      		else
      			-- Si no, sera el siguiente nodo del ULTIMO nodo de la cola
         		en_la_Cola.Ptr_Ultimo.Ptr_Siguiente := nuevoNodo;
      		end if;
      		-- Y ahora sera el ultimo nodo de la cola
      		en_la_Cola.Ptr_Ultimo := nuevoNodo;	
	end Poner;
	
	-- Quitar nodo de lo cola
	procedure Quitar (un_Elemento: out elemento_t; de_la_Cola: in out cola_t) is
		nodoQuitado, nodoSiguiente : ref_Nodo;
	begin
		-- Si la cola no esta vacia
		if de_la_Cola.Ptr_Primero /= null then
         		nodoQuitado := de_la_Cola.Ptr_Primero;
         		un_Elemento := nodoQuitado.Datos;
         		nodoSiguiente := nodoQuitado.Ptr_Siguiente;
         		de_la_Cola.Ptr_Primero := nodoSiguiente;
         		
         		if de_la_Cola.Ptr_Primero = null then
         			de_la_Cola.Ptr_Ultimo := null;
         		end if;
      		else
         		Put_Line("La cola está vacía, no se puede quitar ningún elemento");
      		end if;
	end Quitar;
	
	-- Comprobar si la cola esta vacia
	function Esta_Vacia (La_Cola: cola_t) return Boolean is
	begin
		return La_Cola.Ptr_Primero = null;
	end Esta_Vacia;
	
	-- Comprobar si esta llena
	function Esta_Llena (La_Cola: cola_t) return Boolean is
	begin
		-- Las colas no tienen un tamano definido
		return false;
	end Esta_Llena;
	
	-- Mostrar valores de la cola usando el to string de cada elemento
	procedure MostrarCola (La_Cola: cola_t) is
		nodoActual : ref_Nodo := La_Cola.Ptr_Primero;
	begin
		while nodoActual /= null loop
			Put(ToString(nodoActual.Datos) & ",");
			nodoActual := nodoActual.Ptr_Siguiente;
		end loop;
		Put_Line("");
	end MostrarCola;
	
	-- Copiar los valores de la cola origen en el destino
	procedure Copiar (Origen: cola_t; Destino:in out cola_t) is
		nodoActual : ref_Nodo := Origen.Ptr_Primero;
	begin
		Destino.Ptr_Primero := null;
		Destino.Ptr_Ultimo := null;
		while nodoActual /= null loop
			Poner(nodoActual.Datos, Destino);
			nodoActual := nodoActual.Ptr_Siguiente;
		end loop;
	end Copiar;
	
	-- Comprobar si dos colas son iguales o no
	function "="(La_Cola, Con_La_Cola: cola_t) return Boolean is
		nodoActual1 : ref_Nodo := La_Cola.Ptr_Primero;
		nodoActual2 : ref_Nodo := Con_La_Cola.Ptr_Primero;
	begin
		while nodoActual1 /= null and then nodoActual2 /= null loop
			if nodoActual1.Datos /= nodoActual2.Datos then
				return false;
			end if;
			nodoActual1 := nodoActual1.Ptr_Siguiente;
			nodoActual2 := nodoActual2.Ptr_Siguiente;
		end loop;
		-- si ambos ya son null hemos recorrido ambas colas y en cada iteracion han sido iguales, si no son null una de las colas tiene un tamano superior
		return (nodoActual1 = null) and (nodoActual2 = null);
	end "=";

	
	
end Colas;
