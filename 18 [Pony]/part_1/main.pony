use "files"
use "collections"

class Instruction
    var register: String = ""
    var op: String = ""
    var value: (String | I64) = 0
    var jump_check: (String | I64) = 0

    new create(definition: String, env: Env) =>
        let parts = definition.split_by(" ")

        op = try parts(0) else "" end

        if op == "jgz" then
            jump_check = try parts(1).i64() else try parts(1) else "dupa" end end
        else
            register = try parts(1) else "" end
        end

        if parts.size() == 3 then
            value = try parts(2).i64() else try parts(2) else "dupa2" end end
        end

class Register
    var name: String = ""
    var value: I64 = 0

    new create(name': String) =>
        name = name'
        value = 0

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

actor Main
    var instructions: Array[Instruction] = instructions.create()
    var current_instruction: I64 = 0
    var registers: Map[String, Register] = registers.create()
    var last_sound: I64 = -1

    new create(env: Env) =>
        var lines: Array[String] = lines.create()
        try
            let auth = env.root as AmbientAuth
            let file = File(FilePath(auth, "input"))
            for line in file.lines() do
                lines.push(line)
            end
        end

        for line in lines.values() do
            let instruction = Instruction.create(line, env)
            instructions.push(instruction)
        end

        while ((current_instruction >= 0) and (current_instruction < instructions.size().i64())) do
            var instruction = Instruction.create("", env)            
                try instruction = instructions(current_instruction.usize()) end

                let register: Register = registers.get_or_else(instruction.register, Register(instruction.register))
                try registers.insert_if_absent(instruction.register, register) end

                current_instruction = current_instruction + register.apply(instruction, current_instruction, registers)

                match instruction.op
                | "snd" => last_sound = register.value
                | "rcv" =>
                    if register.value != 0 then
                        env.out.print(last_sound.string())
                        current_instruction = -1
                    end
                end
        end