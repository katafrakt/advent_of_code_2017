with Ada.Text_IO;   use Ada.Text_IO;
with GNAT.Regpat;   use GNAT.Regpat;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Part_2 is
   package Associative_Int_To_Int is new Ada.Containers.Ordered_Maps(Integer, Integer);
   use Associative_Int_To_Int;
   
   function Gets_Me_Caught (Layers : Map; Layer : Integer; Picosecond: Integer) return Boolean is
      Layer_Magic_Number : Integer;
   begin
      if Contains (Layers, Layer) then
        Layer_Magic_Number := Layers (Layer) * 2 - 2;
      else
        return False;
      end if;

      if (Layer + Picosecond) mod Layer_Magic_Number = 0 then
         return True;
      else
         return False;
      end if;
   end Gets_Me_Caught;

   function Find_Delay (Layers : Map; Max_Layer : Integer) return Integer is
      Current_Delay : Integer := 0;
      Current_Layer : Integer := 0;
   begin
      loop
         if Current_Layer > Max_Layer then
            return Current_Delay;
         end if;

         if Gets_Me_Caught (Layers, Current_Layer, Current_Delay) then
            Current_Layer := 0;
            Current_Delay := Current_Delay + 1;
         else
            Current_Layer := Current_Layer + 1;
         end if;
      end loop;
   end Find_Delay;

   File : File_Type;
   Re : constant Pattern_Matcher := Compile ("(\d+): (\d+)");
   Matches : Match_Array (0 .. 2);
   Line : Unbounded_String := To_Unbounded_String ("");
   Layers : Map;
   Layers_Cursor : Cursor;
   Success : Boolean;
   Current_Layer : Integer;
   Current_Length : Integer;
   Delays : Integer;
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

   Delays := Find_Delay (Layers, Current_Layer);
   
   Put_Line (Integer'Image (Delays));
end Part_2;