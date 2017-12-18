use "files"
use "collections"

class Instruction
    var register: String = ""
    var op: String = ""
    var value: (String | I64) = 0
    var jump_check: (String | I64) = 0

    new create(definition: String) =>
        let parts = definition.split_by(" ")

        op = try parts(0) else "" end

        if op == "jgz" then
            jump_check = try parts(1).i64() else try parts(1) else "" end end
        else
            register = try parts(1) else "" end
        end

        if parts.size() == 3 then
            value = try parts(2).i64() else try parts(2) else "" end end
        end

class Register
    var name: String = ""
    var value: I64 = 0

    new create(name': String) =>
        name = name'

    fun ref apply(instruction: Instruction, pos: I64, registers: Map[String, Register]): I64 =>
        var offset: I64 = 1
        let instruction_value: I64 = match instruction.value
            | let s: String => get_register_value(registers, s)
            | let x: I64 => x
        else
            0
        end

        match instruction.op
        | "set" => value = instruction_value
        | "add" => value = value + instruction_value
        | "mul" => value = value * instruction_value
        | "mod" => value = value.mod(instruction_value)
        | "rcv" => offset = 0
        | "jgz" => 
            let check_value = match instruction.jump_check
                        | let s: String =>
                            let register: Register = registers.get_or_else(s, Register(instruction.register))
                            register.value
                        | let x: I64 => x
            else
                0
            end
            if check_value > 0 then offset = instruction_value end
        end

        offset

    fun get_register_value(registers: Map[String, Register], name': String): I64 =>
        let register: Register = registers.get_or_else(name', Register(name'))
        register.value

class Program
    var registers: Map[String, Register]
    var instructions: Array[Instruction]
    var queue: Array[I64]
    var current_instruction: I64
    var waiting: Bool
    
    new create(instructions': Array[Instruction]) =>
        instructions = instructions'
        registers = registers.create()
        queue = queue.create()
        current_instruction = 0
        waiting = false

    fun ref run_step(): (I64 | None) =>
        var val_to_send: (I64 | None) = None
        var instruction = Instruction.create("")            
        try instruction = instructions(current_instruction.usize()) end

        let register: Register = registers.get_or_else(instruction.register, Register(instruction.register))
        try registers.insert_if_absent(instruction.register, register) end

        current_instruction = current_instruction + register.apply(instruction, current_instruction, registers)

        match instruction.op
        | "snd" => val_to_send = register.value
        | "rcv" =>
            if queue.size() == 0 then
                waiting = true
            else
                waiting = false
                let num = try queue.shift() else 0 end
                register.value = num
                current_instruction = current_instruction + 1
            end
        end

        val_to_send

    fun terminated(): Bool =>
        (current_instruction < 0) or (current_instruction >= instructions.size().i64())

    fun is_waiting(): Bool =>
        (queue.size() == 0) and waiting

    fun ref enqueue(num: I64) =>
        queue.push(num)

actor Main
    var instructions: Array[Instruction] = instructions.create()
    
    new create(env: Env) =>
        var lines: Array[String] = lines.create()

        try
            let auth = env.root as AmbientAuth
            let file = File(FilePath(auth, "../input"))
            for line in file.lines() do
                lines.push(line)
            end
        end

        for line in lines.values() do
            let instruction = Instruction.create(line)
            instructions.push(instruction)
        end

        var prog_0 = Program.create(instructions)
        var prog_1 = Program.create(instructions)

        var sent_by_1: U64 = 0

        repeat
            var val_to_send_to_1: (I64 | None) = None
            var val_to_send_to_0: (I64 | None) = None

            if not prog_0.terminated() then
                val_to_send_to_1 = prog_0.run_step()
            end 

            if not prog_1.terminated() then
                val_to_send_to_0 = prog_1.run_step()
            end

            match val_to_send_to_0
            | let x: I64 => 
                prog_0.enqueue(x)
                sent_by_1 = sent_by_1 + 1
            | None => None
            end

            match val_to_send_to_1
            | let x: I64 => prog_1.enqueue(x)
            | None => None
            end

        until (prog_0.is_waiting() or prog_0.terminated()) and (prog_1.is_waiting() or prog_1.terminated()) end

        env.out.print(sent_by_1.string())