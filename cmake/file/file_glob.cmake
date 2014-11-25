# an extended glob function
# globs paths relative to base_dir
# glob expressions starting with / will be normally globbed
# expressions not starting with slash will be globbed recrusively
# specifiying the --relative flag will return paths relative to base_dir 
function(file_glob base_dir)
  set(args ${ARGN})
  list_extract_flag(args --relative)
  ans(relative)
  
  set(globs)
  set(globs_recurse)
  foreach(arg ${args})
    string_starts_with("${arg}" /)
    ans(notRecurse)
    if(notRecurse)
      string(SUBSTRING "${arg}" 1 -1 arg)
      list(APPEND globs ${arg})
    else()
      list(APPEND globs_recurse ${arg})
    endif()
  endforeach()
  set(slash /)

  list_combinations(base_dir slash globs)
  ans(globs)

  list_combinations(base_dir slash globs_recurse)
  ans(globs_recurse)


  set(glob_files)
  set(glob_recurse_files)
  if(globs)
    file(GLOB glob_files ${globs})
  endif()
  if(globs_recurse)
    file(GLOB_RECURSE glob_recurse_files ${globs_recurse})
  endif()

  set(files)

  foreach(file ${glob_files} ${glob_recurse_files})
    get_filename_component(file "${file}" REALPATH)
    if(relative)
      file(RELATIVE_PATH file ${base_dir} ${file})
      list(APPEND files "${file}")
    else()
      list(APPEND files "${file}")
    endif()
  endforeach()
  if(files)
    list(REMOVE_DUPLICATES files)
  endif()
 # foreach(file ${files})
 #   message("file ${file}")
 # endforeach()

  
  return_ref(files)
endfunction()
