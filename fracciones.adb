with Ada.Text_IO; use Ada.Text_IO;

package body Fracciones is
	package Ent_Es is new Ada.Text_Io.Integer_Io(Integer);

	-- Maximo Comun Divisor
	function MCD(a, b : Integer) return Integer is
       	Result : Integer := a;
       	Resultado, Result2 : Integer;
        	R : Integer := b;
    	begin
    		if Result >= R then
    			Result := a;
	        	R := b;
	        else 
	        	Result := b;
	        	R := a;
		end if;
			    	
        	while R /= 0 loop
        		Result2 := R;
	        	R := Result mod R;
	        	Result := R;
		end loop;
		
		if Result2 < 0 then
			Resultado := Result2*(-1);
		else
			Resultado := Result2;
		end if;
	
		return Resultado;
    	end MCD;

	-- Fraccion Irreducible
	procedure irreducible (X: in out fraccion_t) is
	        MCD_Fraccion : Integer;
	        fraccion_irreducible : fraccion_t;
    	begin
    		if X.Num = 0 then
			fraccion_irreducible.Num := 0;
			fraccion_irreducible.Den := 1;
		else
			MCD_Fraccion := MCD(X.Num, X.Den);
			if MCD_Fraccion = 0 then
				fraccion_irreducible.Num := X.Num;
				fraccion_irreducible.Den := X.Den;
			else
				fraccion_irreducible.Num := X.Num / MCD_Fraccion;
				fraccion_irreducible.Den := X.Den / MCD_Fraccion;
			end if;
				X.Num := fraccion_irreducible.Num;
				X.Den := fraccion_irreducible.Den;
		end if ;
	end irreducible;

	-- Suma
	function "+" (X, Y: fraccion_t) return fraccion_t is
	 	Resultado : fraccion_t;
	begin
	 	Resultado.Den := X.Den * Y.Den;
	 	Resultado.Num := (X.Num * Integer(Y.Den)) + (Y.num*Integer(X.Den));
	 	
	 	irreducible(Resultado);
	 	return Resultado;
	end "+";
	
	-- Elemento Opuesto
	function "-" (X: fraccion_t) return fraccion_t is
		Resultado : fraccion_t;
	begin	 	
	 	Resultado.Num := -1*X.Num;
	 	Resultado.Den := X.Den;
	 	
	 	irreducible(Resultado);
	 	
	 	return Resultado;
	end "-";
	
	-- Resta
	function "-" (X, Y: fraccion_t) return fraccion_t is
		Resultado : fraccion_t;
	begin
		Resultado := X+(-Y);
		irreducible(Resultado);
		
		return Resultado;
	end "-";
	
	-- Producto
	function "*" (X, Y: fraccion_t) return fraccion_t is
	 	Resultado : fraccion_t;
	begin
		Resultado.Num := X.Num*Y.Num;
		Resultado.Den := X.Den*Y.Den;
		irreducible(Resultado);
		
		return Resultado;
	end "*";
	
	-- Division
	function "/" (X, Y: fraccion_t) return fraccion_t is
		Resultado : fraccion_t;
		Num, Den : Integer;
	begin
		Num := X.Num*Integer(Y.Den);
		Den := Integer(X.Den)*Y.Num;
		
		if Den < 0 then
			Resultado.Num := (-1)*Num;
			Resultado.Den := (-1)*Den;
		elsif Den = 0 then
			Resultado.Num := 0;
			Resultado.Den := 1;
		else 	
			Resultado.Num := Num;
			Resultado.Den := Den;
		end if;
		
		irreducible(Resultado);
		
		return Resultado;
	end "/";
		 
	function "=" (X, Y: fraccion_t) return Boolean is
	begin
	  	if X.Num*Integer(Y.Den) = Integer(X.Den)*Y.Num then
	  		return true;
	 	else
	 		return false;
	 	end if;
	end "=";

	-- Operaciones de entrada/salida con la consola
	procedure Leer (F: out fraccion_t) is
	begin
		irreducible(F);
	end Leer;
	
	procedure Escribir (F: fraccion_t) is
	begin
		Put_Line(F.Num'Image & "/" & F.Den'Image);
	end Escribir;

	-- Constructor de números fraccionarios a partir de números enteros
	function "/" (X, Y: Integer) return fraccion_t is
		Resultado : fraccion_t;
	begin
		if Y < 0 then
			Resultado.Num := (-1)*X;
			Resultado.Den := (-1)*Y;
		else 
			Resultado.Num := X;
			Resultado.Den := Y;
		end if;
		
		irreducible(Resultado);
		
		return Resultado;
	end "/";
	
	-- Operaciones para obtener las partes de una fracción
	function Numerador (F: fraccion_t) return Integer is
	begin
		return F.Num;
	end Numerador;
	
	function Denominador (F:fraccion_t) return Positive is
	begin
		return F.Den;
	end Denominador;
	
	-- Funcion para imprimir fracciones
	function Imprimir (F: fraccion_t) return String is
		numString : String := F.Num'Image;
		denString : String := F.Den'Image;
	begin
		return numString & "/" & denString;
	end Imprimir;
	
end Fracciones;
