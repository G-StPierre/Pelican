let check_if_md filename = (* Could probably benefit from making this generalzied and passing in file extension in future if needed? *)
  Filename.check_suffix filename ".md" || Filename.check_suffix filename ".MD"

let get_md_files path =
  Sys.readdir path
  |> Array.to_list (* This step techinically reallocates everything so O(n) but I'd rather do this functionally  - Possible efficiency loss, realisticalyl negligible*)
  |> List.filter check_if_md
