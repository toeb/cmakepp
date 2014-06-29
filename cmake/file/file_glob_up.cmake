# applies the glob expressions (passed as varargs)
# to the first n directories starting with the specified path
# order of result is in deepest path first
# 0 searches parent paths up to root
function(file_glob_up path n)
  path("${path}")
  ans(path)
  set(globs ${ARGN})

  # /tld is appended because only its parent dirs are gotten 
  path_parent_dirs("${path}/tld" ${n})
  ans(parent_dirs)


  set(all_matches )
  foreach(parent_dir ${parent_dirs})
    file_glob("${parent_dir}" ${globs})
    ans(matches)
    list(APPEND all_matches ${matches})
  endforeach()
  return_ref(all_matches)
endfunction()