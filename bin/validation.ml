include Types
include Errors

let validate_file lines =
  let rec aux keys_count combos_count = function
    | [] ->
        if keys_count = 0 then (
          handle_error "Missing #Keys line.";
        ) else if combos_count = 0 then (
          handle_error "Missing #Combos line.";
        ) else
          true
    | line :: rest ->
        if String.length line = 0 then (
          handle_error "Empty line found.";
        ) else if String.get line 0 = ' ' then (
          handle_error "Line starts with a space.";
        ) else if line = "#Keys" then (
          if keys_count > 0 then (
            handle_error "Multiple #Keys lines found.";
          ) else
            aux (keys_count + 1) combos_count rest
        ) else if line = "#Combos" then (
          if combos_count > 0 then (
            handle_error "Multiple #Combos lines found.";
          ) else
            aux keys_count (combos_count + 1) rest
        ) else
          aux keys_count combos_count rest
  in
  match lines with
  | [] ->
      handle_error "Empty grammar file."
  | "#Keys" :: rest ->
      aux 1 0 rest
  | _ ->
      handle_error "Grammar file must start with #Keys."

let validate_keys lines =
  let is_valid_format line =
    let colon_count = String.fold_left (fun count ch -> if ch = ':' then count + 1 else count) 0 line in
    if colon_count <> 1 then
      false
    else
      try
        let index = String.index line ':' in
        let left_part = String.sub line 0 index in
        let right_part = String.sub line (index + 1) (String.length line - index - 1) in
        String.length left_part > 0 && String.length right_part > 0
      with Not_found -> false
  in
  let rec aux = function
    | [] -> true
    | line :: rest ->
        if is_valid_format line then
          aux rest
        else (
          handle_error ("Invalid syntax in line: '" ^ line ^ "'.");
        )
  in
  aux lines

let validate_combo_line line =
  let parts = String.split_on_char ':' line in
  if List.length parts <> 2 then
      handle_error (Printf.sprintf "Line '%s' does not contain exactly one colon." line);
  let path = List.hd parts in
  let write = List.nth parts 1 in
  if not (Str.string_match (Str.regexp "^[A-Za-z0-9]+\\(-[A-Za-z0-9]+\\)*$") path 0) then
      handle_error ("Invalid Combo on line '" ^ line ^ "'. It should consist of valid keys separated by dashes.");
  if String.trim write = "" then
      handle_error ("Missing combo description on line '" ^ line ^ "'.")