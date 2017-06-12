# C-Make-Utility

Introduction
------------
A simple makefile generator for C code written purely in Ocaml. The generated result is written to the directory as Makefile, and is fully functional and based off of implicit rules. This utility works in the following way:
```
1). Scans the user entered directory to select the code files
2). Reads these files to descide the dependency of each file.
3). Checks weather the code file has a main function. (All C files with a main block are added to all.)
4). Writes the variables (CC & CFLAGS) and sets the entry point all for make to begin.
5). Write the rules for makefile.
6). Writes the clean target.
```

Motivation
----------
I have usually seen that makefiles ease the process of compilation, but are time consuming to write. Additionally, minor errors in the makefile may be time consuming to catch or result in the project not being properly built. Thus, automating this process makes sense.


Usage
-----
This utility is simple to use and provides you different options such as:
```
1). -output: Lets you specify the executable name (if one executable is to be built)
             With multiple executables don't specify this flag. This is flag purely
             optional and if omitted results in an executabe as <Source file name>.x
             
2). -flags:  This option lets you specify the flags for compiling the code files. This
             is purely optional and if omitted results in a makefile with "-g" flag as
             the default option. All the flags must be specified enclosed in double quotes.

3). -source: This option lets you specify the directory where code files are contained. This
             option must be specified.
```

#### Compiling 
```
ocamlc -o cmake str.cma main.ml
```

### Sample usage
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


