let validate_file lines =
  let rec aux keys_count combos_count = function
    | [] ->
        if keys_count = 0 then (
          prerr_endline "Error: Missing #Keys line.";
          exit 1
        ) else if combos_count = 0 then (
          prerr_endline "Error: Missing #Combos line.";
          exit 1
        ) else
          true
    | line :: rest ->
        if String.length line = 0 then (
          prerr_endline "Error: Empty line found.";
          exit 1
        ) else if String.get line 0 = ' ' then (
          prerr_endline "Error: Line starts with whitespace.";
          exit 1
        ) else if line = "#Keys" then (
          if keys_count > 0 then (
            prerr_endline "Error: Multiple #Keys lines found.";
            exit 1
          ) else
            aux (keys_count + 1) combos_count rest
        ) else if line = "#Combos" then (
          if combos_count > 0 then (
            prerr_endline "Error: Multiple #Combos lines found.";
            exit 1
          ) else
            aux keys_count (combos_count + 1) rest
        ) else
          aux keys_count combos_count rest
  in
  match lines with
  | [] ->
      prerr_endline "Error: Empty grammar file.";
      exit 1
  | "#Keys" :: rest ->
      aux 1 0 rest
  | _ ->
      prerr_endline "Error: Grammar file must start with #Keys.";
      exit 1