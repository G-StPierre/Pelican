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
      print_endline "No Markdown files found in the current directory."
    else begin
    let all_links = Scanner.scan_all_files files in
      
      if List.length all_links = 0 then
        print_endline "Found Markdown files, but no [[links]] inside them."
      else begin
        print_endline "Found the following Markdown links:";
        (* 2. Iterate over the links instead of the filenames *)
        List.iter (fun link -> Printf.printf "- [[%s]]\n" link) all_links
      end
    end
