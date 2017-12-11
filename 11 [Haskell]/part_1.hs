import System.IO
import Data.List.Split

consume coords direction =
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

main :: IO ()
main = do
    input <- readFile "input"
    --let input = "ne,ne,ne"
    let steps = splitOn "," input
    let coords = foldl consume [0,0,0] steps
    print $ distance coords