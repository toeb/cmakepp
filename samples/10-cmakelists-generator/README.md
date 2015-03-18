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
my_project/> cml 
```

These commands result in a new CMakeLists file in the current directory.  The projects name is derived by the parent directory's name.  As you can see there is 
an empty section which defined in a line comment which the tools use to identifiy were generated code going to be put.  This allows you to  still
manually edit the CMakeLists.txt file.  However you should be cautious when changing things inside predefined sections because this could cause errors.

*CMakeLists.txt*: 
```cmake
cmake_minimum_required(VERSION 3.0.2)

project(my_project)
## <section name="targets">
## </section>

```

## Step 2 - Adding a target

The first thing you might want to do is to add a target.  Let's say we want a library called `my_lib` and an executable called `my_exe` which depends on it.

```bash
# add the target 
my_project/> cml target library my_lib --create
my_project/> cml target executable my_exe --create
```

Now you can see the scaffolding for a cmake  library and executable target inside the `CMakeLists.txt`.  Every library and executable target get a set of predefined variables which contain all the necessary the necessary information to create it.  

*CMakeLists.txt*: 
```cmake
cmake_minimum_required(VERSION 3.0.2)

project(my_project)
## <section name="targets">
##   <section name="my_lib">
set(sources)
set(link_libraries)
set(include_directories)
add_library(my_lib ${sources})
target_link_libraries(my_lib ${link_libraries})
target_include_directories(my_lib ${include_directories})
##   </section>

##   <section name="my_exe">
set(sources)
set(link_libraries)
set(include_directories)
add_executable(my_exe ${sources})
target_link_libraries(my_exe ${link_libraries})
target_include_directories(my_exe ${include_directories})
##   </section>

## </section>

```


## Step 3 - Adding source files, include directories and dependencies

The bare targets of course do not really do much.  So we have to fill them with content:


```
# add source files to the my_lib target
my_project/> mkdir src/my_lib
my_project/> cd src/my_lib
my_project/src/my_lib/> cml source my_lib my_lib.cpp --append --create-files
my_project/src/my_lib/> cd ../..
my_project/> mkdir includes/my_lib_inc
my_project/> cd includes/my_lib_inc
my_project/includes/my_lib_inc/> cml source my_lib my_lib.h --append --create-files
```

```
# add an include directory to the my_lib target
my_project/includes/> cml include_dirs my_lib my_lib_inc --append
```


All these modifications change the `CMakelists.txt` to the following:
*CMakeLists.txt*: 
```cmake
cmake_minimum_required(VERSION 3.0.2)

project(my_project)
## <section name="targets">
##   <section name="my_lib">
set(sources src/my_lib/my_lib.cpp includes/my_lib_inc/my_lib.h)
set(link_libraries)
set(include_directories includes/my_lib_inc)
add_library(my_lib ${sources})
target_link_libraries(my_lib ${link_libraries})
target_include_directories(my_lib ${include_directories})
##   </section>

##   <section name="my_exe">
set(sources)
set(link_libraries)
set(include_directories)
add_executable(my_exe ${sources})
target_link_libraries(my_exe ${link_libraries})
target_include_directories(my_exe ${include_directories})
##   </section>

## </section>

```


Now we have a working CMake project with two targets of which one depends on the other. This now only only has to be compiled.

## Step 4 - Compiling the Project

Compiling this project is very simple - just do it as you would always do. 

```bash
@template_shell
```


## Conclusion

As you can see I have added alot of funcitonality to `cmakepp` which allows you to use cmake script reflection to modify cmake code.  Of course there are Caveats - like speed:  A command call can take upwards of a second or 2 and for a normal sized `CMakeLists.txt` because the token parser search procedures all are `O(n)`. Also If there are som spectacular strings inside the cmake code it is possible that they might not parsed correctly - but those are squashable bugs.

This functionality is very intereting to me beacuse programmatically altering cmake files would allow to create project scaffolders and generators (like yeoman for web/javascript) which give you an easy start with any new cmake based project.  The final destination for this is to have generator templates which scaffold your whole project and create standard/vanilla cmake files.  In combination with my package manager this can become very powerful.








