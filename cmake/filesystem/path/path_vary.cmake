
#  varies the specified path until it does not exist
# this is done  by appending a random string at the end of the path
# todo: allow something like map_format or a callback to vary a path
function(path_vary path)
  path("${path}")
  ans(base_path)

  set(path "${base_path}")
  while(true)
    
    if(NOT EXISTS "${path}")
      return("${path}")
    endif()

    string(RANDOM rnd)
    set(path "${base_path}${rnd}")
  endwhile()
endfunction()