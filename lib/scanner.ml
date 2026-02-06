type tag = string
type note = { path : string; links : string list; tags : tag list }

let check_if_md filename =
  (* Could probably benefit from making this generalzied and passing in file extension in future if needed? *)
  Filename.check_suffix filename ".md" || Filename.check_suffix filename ".MD"

let rec get_md_files path =
  Sys.readdir path
  |> Array.to_list
     (* This step techinically reallocates everything so O(n) but I'd rather do this functionally  - Possible efficiency loss, realisticalyl negligible*)
  |> List.concat_map (fun file ->
      let full_path = Filename.concat path file in
      if Sys.is_directory full_path then get_md_files full_path
      else if check_if_md full_path then [ full_path ]
      else [])
  |> List.filter check_if_md

let rec read_link (chan : in_channel) (prev : char) (link : string) =
  match input_char chan with
  | ']' -> if prev = ']' then link else read_link chan ']' link
  | c -> read_link chan c (link ^ String.make 1 c)
(* Should look into using a char list or something to increase performance, this copies the whole string each time *)

(* Honestly I have no idea how like nested links work, like is [ test [other_file.md]] valid, because then checking double bracket won't work? *)
let scan_file filepath =
  let in_chan = open_in filepath in
  (* let prev_char = input_char in_chan in *)
  let links = [] in
  let rec read_data chan prev links =
    try
      match input_char chan with
      | '[' ->
          if prev = '[' then 
            let found_link =read_link chan ' ' "" in
            read_data chan ' ' (found_link :: links)
          else read_data chan '[' links
      | c -> read_data chan c links
    with End_of_file -> links
  in
  let result = read_data in_chan ' ' links in
  close_in in_chan;
  result

let scan_all_files files = 
  let rec scan files output =
    match files with
    | h :: t -> scan t (scan_file h @ output) 
    | [] -> output
  in 
  scan files []
