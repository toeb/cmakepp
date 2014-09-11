
# creates a temporary directory 
# you can specify an optional parent directory in which it should be created
# usage: mktemp([where])-> <absoute path>
function(mktemp)
  set(args ${ARGN})

  if("${args}_" STREQUAL "_")
    oocmake_config(temp_dir)
    ans(tmp_dir)
    set(args "${tmp_dir}")
  else()
    path("${args}")
    ans(args)
  endif()

  path_vary("${args}/mktemp")
  ans(path)

  mkdir("${path}")

  return_ref(path)

endfunction()