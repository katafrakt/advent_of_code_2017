import System.IO
import Data.List.Split

new_coords coords direction =
    let x = coords !! 0
        y = coords !! 1
        z = coords !! 2
    in case direction of
        "n" -> [x, y + 1, z - 1]
        "ne" -> [x + 1, y, z - 1]
        "nw" -> [x - 1, y + 1, z]
        "s" -> [x, y - 1, z + 1]
        "sw" -> [x - 1, y, z + 1]
        "se" -> [x + 1, y - 1, z]

distance coords = sum (map abs coords) / 2

consume args direction =
    let coords = fst args
        furthest = snd args
        n_coords = new_coords coords direction
        c_distance = distance n_coords
    in (n_coords, if c_distance > furthest then c_distance else furthest)

main :: IO ()
main = do
    input <- readFile "input"
    --let input = "ne,ne,ne"
    let steps = splitOn "," input
    let result = foldl consume ([0,0,0], 0) steps
    let coords = fst result
    let furthest = snd result
    print $ distance coords
    print $ furthest