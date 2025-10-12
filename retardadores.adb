with Ada.Real_Time; use Ada.Real_Time;
package body Retardadores is
   type array_Elementos is array (1..Tamaño) of Elementos;

   protected Línea_de_Retardo is
      procedure Escribir (el_Elemento: Elementos);
      procedure Leer (un_Elemento: out Elementos);
      procedure Desplazar;
   private
      Línea: array_Elementos;
      Entrada, Salida: Elementos;
   end Línea_de_Retardo;
   protected body Línea_de_Retardo is
      procedure Escribir (el_Elemento: Elementos) is
      begin
         Entrada := el_Elemento;
      end Escribir;
      procedure Leer (un_Elemento: out Elementos) is
      begin
         un_Elemento := Salida;
      end Leer;
      procedure Desplazar is
      begin
         Salida := Línea (Línea'Last);
         Línea (Línea'First+1..Línea'Last) :=
                          Línea (Línea'First..Línea'Last-1);
         Línea (Línea'First) := Entrada;
      end Desplazar;
   end Línea_de_Retardo;

   task Centinela;
   task body Centinela is
      Periodo: constant Time_Span :=
          To_Time_Span (Duration(Retardo)/Duration(Tamaño));
      Instante_Siguiente: Time := Clock;
   begin
      loop
         delay until Instante_Siguiente;
         Línea_de_Retardo.Desplazar;
         Instante_Siguiente := Instante_Siguiente + Periodo;
      end loop;
   end Centinela;

   procedure Escribir (el_Elemento: Elementos) is
   begin
      Línea_de_Retardo.Escribir (el_Elemento);
   end Escribir;
   procedure Leer (un_Elemento: out Elementos) is
   begin
      Línea_de_Retardo.Leer (un_Elemento);
   end Leer;
   procedure Parar is
   begin
      abort Centinela;
   end Parar;
end Retardadores;