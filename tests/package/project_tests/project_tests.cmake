function(test)

  message(INFO discontinued)
  return()

  project_open(".")
  ans(project)

  fwrite("src/main.cpp" "
#include <iostream>
#include <api/header.h>
using namespace std;
int main(int argc, char** argv){
  cout << \"hello world\" << endl;
  lib::myclass obj;
  auto result = obj.add(1,3);
  cout << \"result: \" << result << endl;
}
    ")


  fwrite("include/api/header.h"
"
#pragma once

#include <iostream>

namespace lib{
  class myclass{
  public:
    int add(int lhs, int rhs)const;
  };
}
")

  fwrite("src/lib.cpp"
"
#include <api/header.h>

auto lib::myclass::add(int lhs, int rhs)const -> int{
  return lhs+rhs;
}
")


  ## generate a cmakelists file for the project
  cml(init)


  cml(target mylib add)
  cml(target mylib type library)
  cml(target mylib sources set src/lib.cpp)
  cml(target mylib includes append include)



  cml(target myexe add)
  cml(target myexe type executable)
  cml(target myexe sources set src/main.cpp)
  cml(target myexe links append mylib)
  cml(target myexe includes append include)

    default_package_source()
    ans(package_source)
    map_set(${project} package_source ${package_source})
  
  ## store the project
  project_write(${project})

  # check that everyhing builds
  pushd(--create build)
  # cmake(-DCMAKE_RUNTIME_OUTPUT_DIRECTORY=bin -DCMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG=bin ..)
  # cmake(--build . --passthru)
  # execute("${test_dir}/build/bin/myexe.exe" --passthru)
  popd()


  ## now create the package


  project_open(".")
  ans(project)

  json_print("${project}")

  project_change_dependencies(${project} "github:toeb/cmakepp")



  project_pack(${project})




  explorer(.)


endfunction()

function(project_pack project)
  # get all files necessary 
  # which are all files in subdirectory


  map_new()
  ans(package_descriptor)


  pushtmp()

  fwrite("lol.txt" asdasdasd)

  explorer(.)
  pop()



endfunction()


function(explorer path)

  execute("cmd" /K explorer.exe "${path}")
endfunction()