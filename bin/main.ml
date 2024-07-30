include Parser
include Input

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
    let automaton = Parser.parse in_channel in

    let keys = automaton.keys in

    List.iter (fun key -> print_endline (key.key ^ " " ^ key.value)) keys;


    close_in in_channel;

    Input.init();
    Input.get_input();
  )