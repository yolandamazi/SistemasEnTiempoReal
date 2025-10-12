-- Este programa pretende ilustrar la forma de manejo de las herramientas
-- del entorno de desarrollo en Ada.

-- Paquete estándar que vamos a manejar.
with Ada.Text_Io; use Ada.Text_Io;

-- Procedimiento principal.
procedure numeros is

   -- Declaracion de tipos
   type Luz_de_Trafico_t is (Rojo, Ambar, Verde);

   -- Creación de ejemplares, para la entrada/salida de números, a partir
   -- de los paquete genéricos "Ada.Text_Io.Integer_Io" y
   -- "Ada.Text_Io.Float_Io".
   package Ent_Es is new Ada.Text_Io.Integer_Io(Integer); use Ent_Es;
   package Real_Es is new Ada.Text_Io.Float_Io(Float);
   package Sem_Es is new Ada.Text_Io.Enumeration_IO(Luz_de_Trafico_t);
   

   -- Declaración de variables locales.
   I, J: Integer;
   X, Y: Float;
   semaforo: Luz_de_Trafico_t := Rojo;

-- Cuerpo del procedimiento "Numeros".
begin
   -- Entrada/salida de números enteros.
   -- Lectura de datos
   New_Line;
   Put ("Introduce un número entero: ");
   Ent_Es.Get (I);
   Put ("Introduce otro número entero: ");
   Ent_Es.Get (J);
   New_Line;
   -- Presentación de los resultados en el sistema decimal
   Ent_Es.Put (I); Put ('+');
   Ent_Es.Put (J); Put ('=');
   Put (I+J);
   New_Line;

   -- Presentación de los resultados en binario
   Ent_Es.Put (I, Base => 2);
   Put ('+');
   Ent_Es.Put (J, Base => 2);
   Put ('=');
   Ent_Es.Put (I+J, Base => 2);
   New_Line;

   -- Presentación de los resultados en hexadecimal
   Ent_Es.Put (I, Base => 16);
   Put ('+');
   Ent_Es.Put (J, Base => 16);
   Put ('=');
   Ent_Es.Put (I+J, Base => 16);
   New_Line;

   -- Presentación de los resultados con formato
   Ent_Es.Put (I);
   Put ('+');
   Ent_Es.Put (J, Width => 0);
   Put ('=');
   Ent_Es.Put (I+J, Width => 6);
   New_Line;   New_Line;

   -- Entrada/salida de números reales.
   -- Lectura de los datos
   Put ("Introduce un número real: ");
   Real_Es.Get (X);
   Put ("Introduce otro número real: ");
   Real_Es.Get (Y);
   New_Line;
   -- Presentación de los resultados
   Real_Es.Put (X);  Put ('/');  Real_Es.Put (Y); Put ('=');
   Real_Es.Put (X/Y);
   New_Line;  
   -- Presentación de los resultados con formato
   Real_Es.Put (X, Fore => 2, Aft => 2, Exp => 3);
   Put ('/');
   Real_Es.Put (Y, Fore => 0, Aft => 0, Exp => 0);
   Put ('=');
   Real_Es.Put (X/Y, Fore => 10, Aft => 4, Exp => 0);
   New_Line; New_Line;
   
   -- Mostrar por pantalla el valor del semaforo
   Sem_Es.Put(semaforo);
end numeros;

