let total_limit = 50000000
let length = 303

let rec part_after_zero list_length curpos value current_after_zero =
  if value == total_limit then
    current_after_zero
  else 
    let position = ((curpos + length) mod list_length) + 1 in
    let new_after_zero = 
      if position == 1 then value else current_after_zero in
    part_after_zero (list_length+1) position (value+1) new_after_zero

let () =
  print_int (part_after_zero 1 1 1 0);