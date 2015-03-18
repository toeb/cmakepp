
function(cmakelists_open)
 
  file_find_anchor("CMakeLists.txt" ${ARGN})
  ans(cmakelists_path)
  if(NOT cmakelists_path)
    path("CMakeLists.txt")
    ans(cmakelists_path)
    path_parent_dir_name("${cmakelists_path}")
    ans(project_name)
    set(content "cmake_minimum_required(VERSION ${CMAKE_VERSION})\n\nproject(${project_name})\n")
  else()
    fread("${cmakelists_path}")
    ans(content)
  endif()
  cmakelists_new("${content}" "${cmakelists_path}")
  return_ans()
endfunction()


