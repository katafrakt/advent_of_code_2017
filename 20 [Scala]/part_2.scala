import scala.io.Source
import scala.collection.mutable.ArrayBuffer
import util.control.Breaks._

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
    
    def eq(other: Trival): Boolean =
        this.x == other.x && this.y == other.y && this.z == other.z
}

class Particle(val position: Trival, velocity: Trival, accel: Trival) {
    def move(): Particle = {
        val new_velo = this.velocity + this.accel
        new Particle(this.position + new_velo, new_velo, this.accel)
    }
}

object Part2 extends App {
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
    for(i <- 1 to 10000) {
        for(j <- 0 until particles.length) {
            if(particles(j) != null)
                particles(j) = particles(j).move()
        }

        for(j <- 0 until particles.length) {
            breakable {
                if (particles(j) == null) break
                var collided = false
                var k = 0
                for(k <- (j+1) until particles.length) {
                    breakable {
                        if(particles(k) == null) break
                        if(particles(j).position.eq(particles(k).position)) {
                            particles(k) = null
                            collided = true
                        }
                    }
                }

                if(collided) particles(j) = null
            }
        }
    }

    var count = 0
    for(i <- 0 until particles.length) {
        if(particles(i) != null) {
            count += 1
        }
    }

    println(count)
}
