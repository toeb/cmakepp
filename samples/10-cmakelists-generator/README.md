# Using the `CMakeLists` Generator

The basic `CMakeLists.txt` files for cmake based projects are usually very simple. Their generation lends itself to be automated and for this purpose I developed a parser for `cmake script` which allows you to manipulate it programmatically within cmake itself. You can find all necessary functions in 
[here](/cmake/cmakescript/README.md).

On top of the cmakescript parser I generated utility functions which allow you to modify managed `CMakeLists.txt` files.  The detailed documentation can be found [here](/cmake/cmakelists/README.md).

With this sample I want to show you how you can manipulate a `CMakeList.txt` using the command line interface `cml` (an alias for your shell of choice which is installed when you install `cmakepp`). The command line interface simply wraps functions which you could also use from cmake directly.



## Step 1 - Starting from Scratch

The first thing to do is to create an initial `CMakeLists.txt` file in the directory of your project.

```bash
# create a new directory
./> mkdir my_project
./> cd my_project
my_project/> cml init 
```

These commands result in a new CMakeLists file in the current directory.  The projects name is derived by taking the parent directory's name.  As you can see the code is just vanilla cmake and you can modify it manually as ever you see fit.

*CMakeLists.txt*: 
```cmake
<file does not exist>
```

## Step 2 - Adding a target

The first thing you might want to do is to add a target.  Let's say we want a library called `my_lib` and an executable called `my_exe`.

```bash
# add the target 
./> cml target add my_lib
./> cml target add my_exe executable
```

Now you can see the scaffolding for a cmake  library and executable target inside the `CMakeLists.txt`.  You might have also noticed that what was generated is not a valid `CMakeLists.txt` because there are not source files specified for the lib and the exe.  However this only causes an error if you generate it.  So we need to add source files which leads us to the next section.

*CMakeLists.txt*: 
```cmake
<file does not exist>
```


## Step 3 - Adding source files, include directories and dependencies

Using the command line tool you can easily add files, folders and values to the targets.  The corresponding properties are automatically created or removed. Be sure to add at least something as sources.


```bash
## add source files to the my_lib target from a subdirectory (the files have to exist) 
src/my_lib/> cml target my_lib sources append my_lib.cpp

## add source file from another directory using a glob expression 
includes/my_lib_inc/> cml target my_lib sources append my_lib*.h

## add source file to my_exe 
./> cml target my_exe sources append src/main.cpp

## add an include directory to the my_lib target
include/> cml target my_lib includes append my_lib_inc

## add my_lib dependency to my_exe
include/> cml target my_exe links append my_lib
```


All these modifications culminate in the `CMakelists.txt` as follows:
*CMakeLists.txt*: 
```cmake
<file does not exist>
```


Now we have a working CMake project with two targets of which one depends on the other. This now only only has to be compiled.

## Step 4 - Generating the Project

This step is just for completeness sake. Do as you would normally do with any cmake project.

```bash
./> mkdir build
./> cd build
template_shell(cmake ..)
```

## Conclusion


As you can see I have added alot of funcitonality to `cmakepp` which allows you to use cmake script reflection to modify cmake code.  Of course there are Caveats - like speed:  A command call can take upwards of a second or 2 for a normal sized `CMakeLists.txt` because the token parser and the search procedures all are `O(n)` (`n` being the number of tokens parsed). Also If there are som spectacular strings (something very escap`y) inside the cmake code it is possible that they might not parsed correctly but those are bugs which I can squash as soon as they are found.

This functionality is very intereting to me beacuse programmatically altering cmake files will allow you (and me) to create project scaffolders and generators (like yeoman for web/javascript) which give you an easy start with any new cmake based project.  The final destination for this is to have generator templates which scaffold your whole project and create standard/vanilla cmake files. Especially combination with my package manager this can become very powerful.

Future developement will allow more complete and easier use of the command line client - more powerfull commands, automatic deductions, formatting, ...




