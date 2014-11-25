

# returns the first match in parent dir or parent dirs of path
function(file_find_up path n target)

  path("${path}")
  ans(path)


  # /tld is appended because only its parent dirs are gotten 
  path_parent_dirs("${path}/tld" ${n})
  ans(parent_dirs)

  foreach(parent_dir ${parent_dirs})
    if(EXISTS "${parent_dir}/${target}")
      return("${parent_dir}/${target}")
    endif()
  endforeach()
  return()

endfunction()


