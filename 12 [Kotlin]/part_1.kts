import java.io.File

val regex = Regex("(\\d+) \\<-\\> (.+)")
val pipes: HashMap<Int, List<Int>> = hashMapOf()

fun processLine(line: String) {
    val match = regex.matchEntire(line)
    val (nameStr, connectionsStr) = match!!.destructured
    val key = nameStr.toInt()
    val values = connectionsStr.split(", ").map { str -> str.toInt() }
    pipes.put(key, values)
}

val lines = mutableListOf<String>()
File("input").useLines { ls -> ls.forEach { processLine(it) }}

val toCheck = mutableListOf(0);
val group = hashSetOf(0);

while (!toCheck.isEmpty()) {
    val elem = toCheck.first()
    toCheck.remove(elem)
    
    if (pipes.containsKey(elem)) {
        for (c in pipes.get(elem)!!.iterator()) {
            group.add(c)
            toCheck.add(c)
        }
    }
    
    pipes.remove(elem)
}

println(group.size)