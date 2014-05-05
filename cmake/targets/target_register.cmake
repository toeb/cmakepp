
function(target_register target_name)
  set(args ${ARGN})
  map()
    kv(name ${target_name})
    kv(sources ${ARGN})
  end()
  ans(target)

  map_append(global targets ${target})

endfunction()