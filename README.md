# C-Make-Utility

Introduction
------------

A small scale makefile generator for C language.

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
