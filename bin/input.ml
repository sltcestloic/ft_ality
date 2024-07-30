let init () =
  try
    Sdl.init [`VIDEO];
    ignore (Sdl.Render.create_window_and_renderer ~width:0 ~height:0 ~flags:[Sdlwindow.Borderless]);
    at_exit Sdl.quit
  with
  | e -> raise e


let rec get_input () =
  match Sdl.Event.poll_event () with
  | Some (Sdl.Event.KeyDown evt) ->
      let keycode_str = Sdlkeycode.to_string evt.keycode in
      print_endline keycode_str;
      if keycode_str = "Escape" then (
        ()
      )
      else (
        get_input ()
      )
  | Some (Sdl.Event.Quit _) -> exit 0
  | _ -> get_input ()