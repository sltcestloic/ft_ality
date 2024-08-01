include Types

let get_transition (automaton : Types.automaton) (current_state : string) (read : string) : (Types.transition) option =
  let find_transition state =
      try
          let transitions = Hashtbl.find automaton.transitions state in
          List.find_opt (fun (t: Types.transition) -> t.read = read) transitions
      with
      | Not_found -> None
  in
  match find_transition current_state with
  | Some t -> Some (t)
  | None -> (
      match find_transition "" with
      | Some t -> Some (t)
      | None -> None
  )