open Notty
open Notty_unix
open Pelican

let () =
  let term = Term.create () in
  
  let img = I.string A.(fg cyan ++ st bold) "Pelican" in
  Term.image term img;
      
  ignore (Term.event term); (* Now any key will close the tui and spit out my md files *)
  
  Term.release term;
  let files = Scanner.get_md_files "." in
    
    if List.length files = 0 then
      print_endline "No markdown files found in the current directory."
    else begin
      print_endline "Found the following Markdown files:";
      List.iter (fun f -> Printf.printf "- %s\n" f) files
    end
