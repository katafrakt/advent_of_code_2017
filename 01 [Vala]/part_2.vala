class AdevntOfCode : GLib.Object {
    public static int main(string[] args) {
        var file = FileStream.open("input", "r");
        var input = file.read_line();
        int[] numbers = new int[input.length];
        for(int i=0;i<input.length;i++) {
            numbers[i] = int.parse(input.get_char(i).to_string());
        }

        int sum = 0;
        int rotation = numbers.length/2;
        for(int i=0;i<numbers.length;i++) {
            var index = i;
            if (index < rotation) index+=(rotation*2);
            var num_to_compare = numbers[index-rotation];

            if(num_to_compare == numbers[i]) {
                sum += numbers[i];
            }
        }
        stdout.printf("%d\n", sum);
        return 0;
    }
}