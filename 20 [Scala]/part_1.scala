import scala.io.Source
import scala.collection.mutable.ArrayBuffer

class Trival(val x: Int, val y: Int, val z: Int) {
    def this(numbers: Array[Int]) {
        this(numbers(0), numbers(1), numbers(2))
    }
    
    def +(other: Trival): Trival =
        new Trival(
            this.x + other.x,
            this.y + other.y,
            this.z + other.z
        )
}

class Particle(position: Trival, velocity: Trival, accel: Trival) {
    def move(): Particle = {
        val new_velo = this.velocity + this.accel
        new Particle(this.position + new_velo, new_velo, this.accel)
    }
    
    def distance(): Int =
        Math.abs(this.position.x) + Math.abs(this.position.y) + Math.abs(this.position.z)
}

object Part1 extends App {
    val filename = "input"
    val regex = raw"p=<(.+)>, v=<(.+)>, a=<(.+)>".r
    var particles = ArrayBuffer[Particle]()
    for (line <- Source.fromFile(filename).getLines) {
        line match {
            case regex(position_str, velocity_str, accel_str) => {
                val position = new Trival(position_str.split(",").map(_.toInt))
                val velo = new Trival(velocity_str.split(",").map(_.toInt))
                val accel = new Trival(accel_str.split(",").map(_.toInt))
                particles += new Particle(position, velo, accel)
            }
        }
    }
    
    var i = 0
    var j = 0
    for(i <- 1 to 2000) {
        for(j <- 0 until particles.length) {
            particles(j) = particles(j).move()
        }
    }

    var closest_distance = 100000000
    var idx = 0
    for(i <- 0 until particles.length) {
        if(particles(i).distance() < closest_distance) {
            closest_distance = particles(i).distance()
            idx = i
        }
    }

    println(idx)
    println(closest_distance)
}
