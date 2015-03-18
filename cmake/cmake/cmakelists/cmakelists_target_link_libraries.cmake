##
##
## modifies the source files of the specified managed target
##
## returns the updated list of source files for the specicified target
## 
function(cmakelists_target_link_libraries cmakelists target_name)
  map_tryget(${cmakelists} begin)
  ans(begin)
  cmake_token_range_variable_navigate("${begin}" "targets.${target_name}.include_directories" ${ARGN})
  return_ans()
endfunction()

