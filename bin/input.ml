include Automaton
include Types

let init () =
  try
    Sdl.init [`VIDEO];
    ignore (Sdl.Render.create_window_and_renderer ~width:0 ~height:0 ~flags:[Sdlwindow.Borderless]);
    at_exit Sdl.quit
  with
  | e -> raise e


let rec get_input (automaton: Types.automaton) =
  match Sdl.Event.poll_event () with
  | Some (Sdl.Event.KeyDown evt) ->
      let keycode_str = Sdlkeycode.to_string evt.keycode in
      print_endline keycode_str;
      if keycode_str = "Escape" then (
        ()
      )
      else (
        match get_transition automaton automaton.state keycode_str with
        | Some transition ->
            let new_state = transition.to_state in
            if (transition.write != "") then (
              print_endline transition.write;
            );
            let updated_automaton = { automaton with state = new_state } in
            print_endline (Printf.sprintf "Transitioned to state: %s" new_state);
            get_input updated_automaton
        | None ->
            let updated_automaton = { automaton with state = "" } in
            get_input updated_automaton
      )
  | Some (Sdl.Event.Quit _) -> exit 0
  | _ -> get_input automaton