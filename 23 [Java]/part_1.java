import java.io.File;
import java.io.FileReader;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

class Part1 {
    public static void main(String[] args) {
        ArrayList<HashMap<String, String>> instructions = new ArrayList<HashMap<String, String>>();
        HashMap<String, Integer> registers = new HashMap<String, Integer>();
        registers.put("a", 0);
        registers.put("b", 0);
        registers.put("c", 0);
        registers.put("d", 0);
        registers.put("e", 0);
        registers.put("f", 0);
        registers.put("g", 0);
        registers.put("h", 0);

        try {
            File file = new File("input");
			FileReader fileReader = new FileReader(file);
			BufferedReader bufferedReader = new BufferedReader(fileReader);
            String line;
			while ((line = bufferedReader.readLine()) != null) {
				String[] parts = line.split(" ");
                HashMap<String, String> operation = new HashMap<String, String>();
                operation.put("op", parts[0]);
                operation.put("target", parts[1]);
                operation.put("value", parts[2]);
                instructions.add(operation);
			}

            int current_op = 0;
            int muls = 0;
            while(true) {
                if(current_op < 0 || current_op >= instructions.size()) {
                    break;
                }

                HashMap<String, String> current_instruction = instructions.get(current_op);
                Integer value = getValue(current_instruction.get("value"), registers);
                String target = current_instruction.get("target");
                switch(current_instruction.get("op")) {
                    case "set":
                        registers.put(target, value);
                        break;
                    case "sub":
                        registers.put(target, registers.get(target) - value);
                        break;
                    case "mul":
                        muls++;
                        registers.put(target, registers.get(target) * value);
                        break;
                    case "jnz":
                        if(getValue(target, registers) != 0) {
                            current_op += value - 1;
                        }
                        break;
                }
                current_op++;
            }

            System.out.println(muls);
        } catch (IOException e) {
			e.printStackTrace();
		}
    }

    public static Integer getValue(String value, HashMap<String, Integer> registers) {
        String pattern = "[a-h]";
        Pattern r = Pattern.compile(pattern);
        Matcher m = r.matcher(value);
        if(m.find()) {
            return registers.get(value);
        } else {
            return Integer.parseInt(value);
        }
    }
}