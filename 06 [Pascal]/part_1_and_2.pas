program Advent6;
uses sysutils, classes;

const
    RegisterNum = 16;

var
    registers: array[1..RegisterNum] of integer;
    counter: integer;
    used: TStringList;
    current_signature: string;

function Signature(): string;
var
    i: integer;
    result: string;
begin
    result := '';
    for i := 1 to RegisterNum do
        result := result + IntToStr(registers[i]) + '-';
    Signature := result; 
end;

procedure InitRegisters();
begin
    registers[1] := 5;
    registers[2] := 1;
    registers[3] := 10;
    registers[4] := 0;
    registers[5] := 1;
    registers[6] := 7;
    registers[7] := 13;
    registers[8] := 14;
    registers[9] := 3;
    registers[10] := 12;
    registers[11] := 8;
    registers[12] := 10;
    registers[13] := 7;
    registers[14] := 12;
    registers[15] := 0;
    registers[16] := 6;
end;

function IndexWithMostBlocks(): integer;
var
    i, max, max_index: integer;
begin
    max := registers[1];
    max_index := 1;
    for i := 2 to RegisterNum do
        if registers[i] > max then
        begin
            max := registers[i];
            max_index := i;
        end;
    IndexWithMostBlocks := max_index;
end;

procedure BalanceRegisters();
var
    blocks_to_redistribute, source_index, i, index_value, add_to_all, add_one_to: integer;
begin
    source_index := IndexWithMostBlocks();
    blocks_to_redistribute := registers[source_index];
    registers[source_index] := 0;

    add_to_all := blocks_to_redistribute div RegisterNum;
    add_one_to := blocks_to_redistribute mod RegisterNum;
    for i := 1 to RegisterNum do
        registers[i] := registers[i] + add_to_all;

    for i := 1 to add_one_to do
    begin
        index_value := i + source_index;
        if index_value > RegisterNum then
            index_value := index_value - RegisterNum;
        registers[index_value] := registers[index_value] + 1;
    end;
end;

procedure FindLoop();
begin
    counter := 0;
    used.Clear();
    current_signature := Signature();

    while used.indexOf(current_signature) = -1 do
    begin
        used.Add(current_signature);
        counter := counter + 1;
        BalanceRegisters();
        current_signature := Signature();
    end;
end;

begin
    InitRegisters();
    used := TStringList.Create;

    FindLoop();
    writeln('Part 1: ', counter);

    FindLoop();
    writeln('Part 2: ', counter);
end.