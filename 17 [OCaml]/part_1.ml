let limit = 2017

let rec take n xs = match xs with
| [] -> []
| x::xs -> if n=1 then [x] else if n=0 then [] else x::take (n-1) xs;;

let drop n xs = List.rev (take ((List.length xs) - n) (List.rev xs));;

let rec circulate curlist curpos len cycles_left =
  match cycles_left with
  | 0 -> curlist
  | _ -> let val_to_insert = limit - cycles_left + 1 in
          let position = ((curpos + len) mod (List.length curlist)) + 1 in
          let head = take position curlist in
          let tail = drop position curlist in
          let newlist = List.append head (val_to_insert :: tail) in
          circulate newlist position len (cycles_left - 1);;

let rec find_after curlist value =
  let head = List.hd curlist in
  let tail = List.tl curlist in
  if head == value then List.hd tail else find_after tail value;;

let find_section start_list length value =
  let full_list = circulate [0] 1 length limit in
  find_after full_list value;;

let () = print_int (find_section [0] 303 limit);;