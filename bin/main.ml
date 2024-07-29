include Parser

let () =
  if Array.length Sys.argv != 2 then (
    print_string "Usage: ";
    print_string Sys.argv.(0);
    print_endline " [file]";
  )
  else (
    let filename = Sys.argv.(1) in
    if not (Sys.file_exists filename) then (
      print_endline "File does not exist.";
      exit 1
    );
    let in_channel = open_in filename in
    let keys, combos = Parser.parse in_channel in

    Printf.printf "Keys:\n%s\n" (String.concat "\n" keys);
    Printf.printf "Combos:\n%s\n" (String.concat "\n" combos);

    close_in in_channel;
  )