let out = ref ""
let all = ref []
let re_dep = Str.regexp "#include \"[a-zA-Z][a-zA-Z0-9-]*\\.h\""
let re_main = Str.regexp "main("
let rules = ref ""

let print_usage () =
  print_string "\nThis file functions as a driver for interfacing with the C-make-utility\n";
  print_string "Usage:\n";
  print_string "\t cmake -output <output_executable_name>(optional) -source <path_to_the_folder_containing_code_files>\n";
  exit 1

let read_from_file input_filename  =
  let read_lines name : string list =
    let ic = open_in name in
    let try_read () =
      try Some (input_line ic) with End_of_file -> None in
    let rec loop acc = match try_read () with
      | Some s -> loop (s :: acc)
      | None -> close_in ic; List.rev acc in
    loop []
  in
  let prog_lines = read_lines input_filename in
  List.fold_left (fun a e -> a ^ e ^ "\n") "" prog_lines


let args = match Array.to_list Sys.argv with
  | _::"-output"::t ->( match t with
                        |l::t2 ->( match t2 with 
                                    |"-source"::n::[] -> (l,n)
                                    | _ -> print_usage ()
                         )  
                        | _ -> print_usage ()         
                      )
  |_ ::"-source"::t -> ( match t with
                          |n::[] -> ("",n)
                          | _ -> print_usage ()
                         
                      )
  | _ -> print_usage ()
;;



let is_header name = let len = String.length name in let ext = String.get name (len - 1) in ext = 'h'
let rem_ext name = let len = String.length name in String.sub name 0 (len-1)
let code_files name = let len = String.length name in let ext = String.sub name (len - 2) 2 in ext = ".c"
let update_all entry = all := entry::(!all)

let rec get_deps code =  let rec tok str pos = 
                            if pos >= String.length str then []
                            else (
                                 if (Str.string_match re_dep str pos) then
                                   let comm = Str.matched_string str in
                                          comm::(tok str (pos + String.length comm))
                                   else 
                                        (tok str (pos + 1))
                                )
                          in tok code 0
                       

let rec has_main code = let rec tok str pos = 
                            if pos >= String.length str then false
                            else (
                                 if (Str.string_match re_main str pos) then
                                    true
                                   else 
                                        (tok str (pos + 1))
                                )
                          in tok code 0
  
let extract_dep statement = let _ = Str.string_match (Str.regexp "#include \"") statement 0 in 
let extra_len = String.length (Str.matched_string statement) in 
String.sub statement extra_len ((String.length statement) - extra_len - 1) 

let gen_dep deps  = List.fold_left (fun a e -> (extract_dep e)^ " " ^ a) "" deps 

let gen_target deps file = if (is_header file && deps <> []) then file^": "^ (gen_dep deps)^"\n\t touch "^file 
                           else if (is_header file = false && deps <> []) then (rem_ext file)^"o: "^(gen_dep deps)^" "^file 
                           else if (code_files file && deps = []) then (rem_ext file^"o: "^file)
                           else ""


let gen_dep_main deps = List.fold_left (fun a e -> (rem_ext (extract_dep e))^ "o " ^ a) "" deps 

let gen_target_main deps file_name = let file_base =  (rem_ext file_name) in 
let deps = (gen_dep_main deps)^file_base^"o" in 
if (!out <> "") then 
 (!out)^": "^deps^("\n\t$(CC) -o "^(!out)^" " ^deps)
else
(
 update_all file_name;
 file_base^"x: $(CC) -o "^file_base^"x "^deps
)


let sub_rules deps file_name base  = let rule = (gen_target deps file_name) in 
rules := (!rules)^rule^"\n"


let main_rules deps file_name base is_cont = if is_cont then
(
let rule = (gen_target_main deps file_name) in 
let _ = rules := (!rules)^rule^"\n" in 
()
)
else ()

let reject e = let c = (String.get e 0) in c <> '.'

let process_rules file_name base = let code = read_from_file (base^"/"^file_name) in let deps = get_deps code in 
let is_cont = has_main code in 
let _ = main_rules deps file_name base is_cont in
sub_rules deps file_name base 

let  rec gen_rules lst basename = match lst with
| [] -> ()
| h::t -> let _ = process_rules h basename
          in gen_rules t basename


let get_all lst = List.fold_left (fun a e -> (rem_ext e)^ "x " ^ a) "" lst

let write_base base= let oc = open_out  (base^"/Makefile") in
Printf.fprintf oc "%s\n" ("CC = gcc\nall: "^(!out)^(get_all !all)^"\n");
close_out oc


let write_clean base = let oc = open_out_gen [Open_creat; Open_text; Open_append] 0o640 (base^"/Makefile") in
Printf.fprintf oc "%s\n" ("\nclean: \n\trm -f *.o *.x "^(!out));
close_out oc

let write_rules base = let oc = open_out_gen [Open_creat; Open_text; Open_append] 0o640 (base^"/Makefile") in
Printf.fprintf oc "%s\n" (!rules);
close_out oc



let main () = let (output,file) = args in 
out := output;
gen_rules (List.filter reject (Array.to_list (Sys.readdir file))) file;
write_base file;
write_rules file;
write_clean file

let _ = main () ;;