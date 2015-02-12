# Adding Boost to you `CMake` project





C:/temp/cutil/temp/mktempmXsps/boost;C:/temp/cutil/temp/mktempmXsps/CMakeLists.txt;C:/temp/cutil/temp/mktempmXsps/main.cpp;C:/temp/cutil/temp/mktempmXsps/README.md;C:/temp/cutil/temp/mktempmXsps/README.md.in


*CMakeLists.txt*: 
```cmake
cmake_minimum_required(VERSION 2.8.12)

include("$ENV{CMAKEPP_PATH}")


project(MyProject)
project_open(. --force)


add_executable(myexe main.cpp)

```


```
./> pkg install ./boost
@cmakepp(cmakepp_project_cli install ./boost)
./> 
./build/> cmake .. 
-- Building for: Visual Studio 12 2013
-- The C compiler identification is ;MSVC 18.0.31101.0
-- The CXX compiler identification is ;MSVC 18.0.31101.0
-- Check for working C compiler using: Visual Studio 12 2013
-- Check for working C compiler using: Visual Studio 12 2013 -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Check for working CXX compiler using: Visual Studio 12 2013
-- Check for working CXX compiler using: Visual Studio 12 2013 -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Found Git: C:/Program Files (x86)/Git/cmd/git.exe (found version "1.9.4.msysgit.2") 
-- Found Hg: C:/Program Files/Mercurial/hg.exe (found version "3.2.1") 
-- Found Subversion: C:/Program Files (x86)/Subversion/bin/svn.exe (found version "1.8.11") 
-- Configuring done
-- Generating done
-- Build files have been written to: C:/temp/cutil/temp/mktempmXsps/build

./build/> cmake --build .
 ...
./build/>./bin/myexe 
hello


```

