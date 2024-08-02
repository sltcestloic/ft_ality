include Validation
include Types
include Errors

let parse_keys (lines: string list) : key list =
  let parse_line line =
    match String.split_on_char ':' line with
    | [key; value] -> { key = key; value = value }
    | _ ->
        handle_error ("Error: Invalid key-value format in line: " ^ line);
  in
  List.map parse_line lines

let parse_combos (lines: string list) (keys: key list) : (string, transition list) Hashtbl.t =
  let key_map = List.fold_left (fun acc k -> Hashtbl.add acc k.value k.key; acc) (Hashtbl.create (List.length keys)) keys in
  let transitions = Hashtbl.create 10 in

  let process_line line =
      validate_combo_line line;
      let parts = String.split_on_char ':' line in
      let path = List.hd parts in
      let write = List.nth parts 1 in
      let states = String.split_on_char '-' path in

      let add_transition from_state read to_state write =
          let existing_transitions =
              if Hashtbl.mem transitions from_state then
                  Hashtbl.find transitions from_state
              else
                  []
          in
          let updated_transitions = List.map (fun t ->
              if t.read = read then
                  { t with to_state; write = if t.write = "" then write else t.write }
              else
                  t
          ) existing_transitions in
          let new_transition =
              if List.exists (fun t -> t.read = read) existing_transitions then
                  updated_transitions
              else
                  existing_transitions @ [{ read; to_state; write }]
          in
          Hashtbl.replace transitions from_state new_transition
      in

      let rec create_transitions current_path remaining_states =
          match remaining_states with
          | [] -> ()
          | [state] ->
              if not (Hashtbl.mem key_map state) then
                  handle_error (Printf.sprintf "State '%s' not found in keys." state);
              let corresponding_key = Hashtbl.find key_map state in
              let next_state = if current_path = "" then state else current_path ^ "-" ^ state in
              add_transition current_path corresponding_key next_state (String.trim write)
          | state :: rest ->
              if not (Hashtbl.mem key_map state) then
                  handle_error (Printf.sprintf "State '%s' not found in keys." state);
              let corresponding_key = Hashtbl.find key_map state in
              let next_state = if current_path = "" then state else current_path ^ "-" ^ state in
              add_transition current_path corresponding_key next_state "";
              create_transitions next_state rest
      in

      create_transitions "" states
  in

  List.iter process_line lines;
  transitions

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
      let keys, combos = split_keys_combos lines in
      let keysList = parse_keys keys in
      if not (validate_keys keys) then (
        handle_error "syntax error in keys";
      );
      let combosList = parse_combos combos keysList in
      let automaton = {
        keys = keysList;
        state = "";
        transitions = combosList;
      } in
      (automaton)
    else (
      handle_error "Invalid file format: file contains empty lines";
    )
  with e ->
    close_in_noerr ic;
    raise e