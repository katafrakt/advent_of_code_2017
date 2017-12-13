with Ada.Text_IO;   use Ada.Text_IO;
with GNAT.Regpat;   use GNAT.Regpat;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Part_1 is
   package Associative_Int_To_Int is new Ada.Containers.Ordered_Maps(Integer, Integer);
   use Associative_Int_To_Int;
   
   function Severity_For (Layers : Map; Layer : Integer) return Integer is
      Layer_Magic_Number : Integer;
   begin
      if Contains (Layers, Layer) then
        Layer_Magic_Number := Layers (Layer) * 2 - 2;
      else
        return 0;
      end if;

      if Layer mod Layer_Magic_Number = 0 then
         return Layer * Layers (Layer);
      else
         return 0;
      end if;
   end Severity_For;


   File : File_Type;
   Re : constant Pattern_Matcher := Compile ("(\d+): (\d+)");
   Matches : Match_Array (0 .. 2);
   Line : Unbounded_String := To_Unbounded_String ("");
   Layers : Map;
   Layers_Cursor : Cursor;
   Success : Boolean;
   Current_Layer : Integer;
   Current_Length : Integer;
   Severity : Integer := 0;
begin
   Open (File => File,
         Mode => In_File,
         Name => "input");
   loop
      exit when End_Of_File (File);
      
      Line := To_Unbounded_String (Get_Line (File));
      Match (Re, To_String (Line), Matches);
      Current_Layer := Integer'Value (To_String (Line) (Matches (1).First .. Matches (1).Last));
      Current_Length := Integer'Value (To_String (Line) (Matches (2).First .. Matches (2).Last));
      Layers.Insert(Current_Layer, Current_Length, Layers_Cursor, Success);
   end loop;
 
   Close (File);

   Main_Loop:
      for I in Integer range 0 .. Current_Layer loop
        Severity := Severity + Severity_For (Layers, I);
      end loop Main_Loop;

   Put_Line (Integer'Image (Severity));
end Part_1;