type automaton = Types.automaton

let split_keys_combos lines =
  let rec aux keys combos is_keys is_combos = function
    | [] -> (List.rev keys, List.rev combos)
    | "#Keys" :: rest -> aux keys combos true false rest
    | "#Combos" :: rest -> aux keys combos false true rest
    | line :: rest when is_keys -> aux (line :: keys) combos true false rest
    | line :: rest when is_combos -> aux keys (line :: combos) false true rest
    | _ :: rest -> aux keys combos is_keys is_combos rest
  in
  aux [] [] false false lines

let rec read_lines ic lines =
  try
    let line = input_line ic in
    read_lines ic (line :: lines)
  with End_of_file ->
    close_in ic;
    List.rev lines

let parse ic =
  try
    let lines = read_lines ic [] in
    let keys, combos = split_keys_combos lines in
    (keys, combos)
  with e ->
    close_in_noerr ic;
    raise e