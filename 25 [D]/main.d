import std.stdio;

struct Instruction {
    int value_to_write;
    int move;
    char next_state;
}

struct State {
    Instruction[int] instructions;

    this(int zero_to_write, int zero_move, char zero_next, int one_to_write, int one_move, char one_next) {
        instructions[0] = Instruction(zero_to_write, zero_move, zero_next);
        instructions[1] = Instruction(one_to_write, one_move, one_next);
    }
}

void main() {
    State[char] states;
    states['A'] = State(1, 1, 'B', 0, -1, 'C');
    states['B'] = State(1, -1, 'A', 1, 1, 'D');
    states['C'] = State(1, 1, 'A', 0, -1, 'E');
    states['D'] = State(1, 1, 'A', 0, 1, 'B');
    states['E'] = State(1, -1, 'F', 1, -1, 'C');
    states['F'] = State(1, 1, 'D', 1, 1, 'A');

    int[int] tape;
    int current_index = 0;
    char current_state = 'A';

    for(int i = 0; i < 12173597; i++) {
        auto state = states[current_state];
        auto value = tape.get(current_index, 0);
        auto instruction = state.instructions[value];

        tape[current_index] = instruction.value_to_write;
        current_state = instruction.next_state;
        current_index += instruction.move;
    }

    int checksum = 0;
    foreach(int i; tape.byValue()) {
        checksum += i;
    }

    writeln(checksum);
}