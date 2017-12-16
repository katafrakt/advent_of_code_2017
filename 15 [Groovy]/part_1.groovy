def a_value = BigInteger.newInstance("703")
def b_value = BigInteger.newInstance("516")

// test
//a_value = BigInteger.newInstance("65")
//b_value = BigInteger.newInstance("8921")

def a_factor = 16807
def b_factor = 48271
def magic_divisor = BigInteger.newInstance("2147483647")

def limit = 2 ** 16
def iterations = 4 * (10 ** 7)

def equals_count = 0

iterations.times {
    a_value = (a_value.multiply(a_factor)).mod(magic_divisor)
    b_value = (b_value.multiply(b_factor)).mod(magic_divisor)

    if ((a_value.mod(limit)) == (b_value.mod(limit))) {
        equals_count++
    }
}

println equals_count