type tag = string

type note = {
  path : string;
  links : string list;
  tags: tag list;
  }

val get_md_files : string -> string list
val scan_all_files : string list -> string list
