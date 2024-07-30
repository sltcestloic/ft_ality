module Types = struct
  type automaton = {
    keys: key list;
    states: string list;
    state: string;
    transitions: (string, transition list) Hashtbl.t;
  }

  and transition = {
    read : string;
    to_state : string;
    write : string;
  }

  and key = {
    key: string;
    value: string;
  }
end 
