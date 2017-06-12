# C-Make-Utility

Introduction
------------
A simple makefile generator for C code written purely in Ocaml. The generated result is written to the directory as Makefile, and is fully functional. This utility works in the following way:
```
1). Scans the user entered directory to select the code files
2). Reads these files to descide the dependency of each file.
3). Checks weather the code file has a main function. (All C files with a main block are added as targets to build the executables.)
4). Writes the variables (CC & CFLAGS) and sets the entry point all for make to begin.
5). Write the rules for makefile.
6). Writes the clean target.
```


#### Compiling 
```
ocamlc -o cmake str.cma main.ml
```

#### Usage
```
./cmake -source <Enter_the_ouput_file_name> -source <path_to_folder_containing_code_files>
Example:
./cmake -source shell.x -source /Projects/shell
```
##### For multiple exectable targets
``` 
./cmake -source <path_to_folder_containing_code_files>
Example:
./cmake -source /Projects/shell
```

##### For specifing flags
``` 
cmake -output <output_executable_name>(optional) -flags "specify_flags" -source <path_to_the_folder_containing_code_files>
Example:
./cmake -output shell.x -flags "-ansi -Wall -g" -source /Projects/shell
```

#### Flags
The default flag is "-g" if you don't specify any.
