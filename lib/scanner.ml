let check_if_md filename = (* Could probably benefit from making this generalzied and passing in file extension in future if needed? *)
  Filename.check_suffix filename ".md" || Filename.check_suffix filename ".MD"

let rec get_md_files path =
  Sys.readdir path
  |> Array.to_list (* This step techinically reallocates everything so O(n) but I'd rather do this functionally  - Possible efficiency loss, realisticalyl negligible*)
  |> List.concat_map (fun file ->
    let full_path = Filename.concat path file in
    if Sys.is_directory full_path then
    get_md_files full_path
    else if check_if_md full_path then 
      [full_path]
    else
      [])
  |> List.filter check_if_md
