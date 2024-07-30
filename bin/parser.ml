include Validation
include Types

let parse_keys (lines: string list) : key list =
  let parse_line line =
    match String.split_on_char ':' line with
    | [key; value] -> { key = key; value = value }
    | _ ->
        prerr_endline ("Error: Invalid key-value format in line: " ^ line);
        exit 1
  in
  List.map parse_line lines

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
    if validate_file(lines) then
      let keys, _combos = split_keys_combos lines in
      if (validate_keys keys) then (
        print_endline "Keys and combos are valid";
        let keysList = parse_keys keys in
        let automaton = {
          keys = keysList;
          states = [];
          state = "";
          transitions = Hashtbl.create 10;
        } in
          List.iter (fun key -> print_endline (key.key ^ " " ^ key.value)) keysList;
        (automaton)
      ) else
        ({keys = []; states = []; state = ""; transitions = Hashtbl.create 10})
    else (
      print_endline "Invalid file format: file contains empty lines";
      exit 1
    )
  with e ->
    close_in_noerr ic;
    raise e