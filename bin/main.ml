include Parser
include Input

let print_key key =
  Printf.printf "Key: %s, Value: %s\n" key.key key.value

let print_transition transition =
  Printf.printf "Read: %s, To State: %s, Write: %s\n"
      transition.read transition.to_state transition.write

let print_transitions transitions =
  Hashtbl.iter (fun state transition_list ->
      Printf.printf "State: %s\n" state;
      List.iter print_transition transition_list
  ) transitions

let print_keys keys =
  List.iter print_key keys

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

    (* Print keys and transitions *)
    Printf.printf "Keys:\n";
    print_keys automaton.keys;

    Printf.printf "\nTransitions:\n";
    print_transitions automaton.transitions;

    close_in in_channel;

    
  )