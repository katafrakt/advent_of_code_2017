class Demo.HelloWorld : GLib.Object {
    public static int main(string[] args) {
        var file = FileStream.open("input", "r");
        var input = file.read_line();
        int[] numbers = new int[input.length];
        for(int i=0;i<input.length;i++) {
            numbers[i] = int.parse(input.get_char(i).to_string());
        }

        int sum = 0;
        int previous_num = numbers[numbers.length-1];
        for(int i=0;i<numbers.length-1;i++) {
            if(previous_num == numbers[i]) {
                sum += numbers[i];
            }
            previous_num = numbers[i];
        }
        stdout.printf("%d\n", sum);
        return 0;
    }
}