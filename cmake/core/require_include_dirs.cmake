
  function(require_include_dirs )
    require_map()
    ans(map)
    map_get(${map} stack include_dirs)
    stack_pop(${stack})
    ans(dirs)
    list(APPEND dirs ${ARGN})
    stack_push(${stack} ${dirs})

  endfunction()
