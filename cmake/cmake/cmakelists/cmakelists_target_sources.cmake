##
##
## modifies the source files of the specified managed target
##
## returns the updated list of source files for the specicified target
## 
function(cmakelists_target_sources cmakelists target_name)
  set(args ${ARGN})

  list_extract_flag_name(args --create-files)
  ans(create_files)

  list_contains_any(args --append --set --insert)
  ans(add_operation)

  if(NOT add_operation)
    set(create_files)
  endif()
  regex_cmake()
  set(files ${args})
  list_extract_matches(files "^${regex_cmake_double_dash_flag}$" )
  ans(flags)

  cmakelists_paths(${cmakelists} ${files} ${create_files} )
  ans(files)



  cmakelists_variable(${cmakelists} "targets.${target_name}.sources" ${files} ${flags})
  return_ans()  
endfunction()
