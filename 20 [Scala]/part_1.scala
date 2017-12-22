import scala.io.Source

class Trival(x: Int, y: Int, z: Int) {}

class Point(position: Trival, velocity: Trival, accel: Trival) {
}

object Part1 extends App {
    val filename = "input"
    val regex = raw"p=<(.+)>, v=<(.+)>, a=<(.+)>".r
    var points = Array[Point]
    for (line <- Source.fromFile(filename).getLines) {
        line match {
            case regex(position_str, velocity_str, accel_str) => {
                val position = new Trival(position_str.split(",").map(_.toInt))
                val velo = new Trival(velocity_str.split(",").map(_.toInt))
                val accel = new Trival(accel_str.split(",").map(_.toInt))
                points.push(new Point(position, velo, accel))
            }
        }
    }
}
