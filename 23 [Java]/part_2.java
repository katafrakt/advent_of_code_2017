class Part2 {
    public static void main(String[] args) {
        int a = 1;
        int b = 0;
        int c = 0;
        int d = 0;
        int e = 0;
        int f = 0;
        int g = 0;
        int h = 0;

        b = 81;
        c = b;

        if (a != 0) {
            b *= 100;
            b += 100000;
            c = b;
            c += 17000;
        }

        do {
            f = 1;
            d = 2;
            do {
                e = 2;
                if (b % d == 0) f = 0;
                e = b;
                g = 0;

                d += 1;
                g = d;
                g -= b;
            } while (g != 0);

            if (f == 0) h++;

            g = b;
            g -= c;
            
            if (g == 0) break;
            b += 17;  
        } while (true);

        System.out.println(h);
    }

}