#!/usr/bin/env escript

main([String]) ->
    Instructions = readlines(String),
    Registers = #{},
    {ProcessedRegisters, LargestEver} = process_instructions(Instructions, Registers, 0),
    Largest = find_largest_value(ProcessedRegisters),
    io:format("part 1: ~w~n", [Largest]),
    io:format("part 2: ~w~n", [LargestEver]).

readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
    get_all_lines(Device, []).

get_all_lines(Device, Accum) ->
        case io:get_line(Device, "") of
            eof  -> file:close(Device), Accum;
            Line -> get_all_lines(Device, Accum ++ [Line])
        end.

process_instructions([], Registers, CurrentLargest) ->
    {Registers, CurrentLargest};

process_instructions([Head | Tail], Registers, CurrentLargest) ->
    [TargetRegister, Operation, Value, "if", SourceRegister, Operator, ComparisonValue] = string:tokens(Head, " "),
    NewRegisters = case check_conditions(SourceRegister, Operator, ComparisonValue, Registers) of
        true -> perform_operation(Registers, TargetRegister, Operation, Value);
        false -> Registers
    end,
    
    NewLargestCandidate = find_largest_value(NewRegisters),
    NewLargest = if 
        NewLargestCandidate > CurrentLargest -> NewLargestCandidate;
        true -> CurrentLargest
    end,

    process_instructions(Tail, NewRegisters, NewLargest).

check_conditions(Register, Operator, ValueStr, Registers) ->
    {Value, _} = string:to_integer(ValueStr),
    CurrentValue = get_register_value(Registers, Register),
    case Operator of
        ">" -> CurrentValue > Value;
        ">=" -> CurrentValue >= Value;
        "<" -> CurrentValue < Value;
        "<=" -> CurrentValue =< Value;
        "==" -> CurrentValue == Value;
        "!=" -> CurrentValue /= Value
    end.

perform_operation(Registers, Register, Operation, ValueStr) ->
    {Value, _} = string:to_integer(ValueStr),
    CurrentValue = get_register_value(Registers, Register),
    NewValue = case Operation of
        "inc" -> Value + CurrentValue;
        "dec" -> CurrentValue - Value
    end,
    maps:put(Register, NewValue, Registers).

find_largest_value(Registers) ->
    List = maps:values(Registers),
    lists:max(List).

get_register_value(Registers, Key) ->
    maps:get(Key, Registers, 0).