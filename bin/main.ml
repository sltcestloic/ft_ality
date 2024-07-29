include Parser

let () =
  if Array.length Sys.argv != 1 then (
    print_string "Usage: ./";
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
    Parser.parse in_channel;
  )