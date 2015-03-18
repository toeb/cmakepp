

## modifies the include directories of the specified target in a managed cmakelsits file
function(cmakelists_target_include_directories cmakelists target_name)
  set(args ${ARGN})
  map_tryget(${cmakelists} begin)
  ans(begin)

  list_extract_flag_name(args --create-dirs)
  ans(create_files)

  list_contains_any(args --append --set --insert)
  ans(add_operation)
  if(NOT add_operation)
    set(create_files)
  endif()
  
  regex_cmake()
  set(dirs ${args})
  print_vars(dirs)

  list_extract_matches(dirs "^${regex_cmake_double_dash_flag}$" )
  ans(flags)
  cmakelists_paths(${cmakelists} ${dirs} ${create_files} )
  ans(dirs)

  print_vars(target_name flags dirs begin)
  
  cmake_token_range_variable_navigate(
    "${begin}" 
    "targets.${target_name}.include_directories" 
    ${dirs} ${flags} --remove-duplicates)
  ans(res)
  print_vars(res)
  return_ref(res)
  return_ans()
endfunction()
