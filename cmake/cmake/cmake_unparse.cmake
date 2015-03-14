
  function(cmake_unparse root)
    set(str)
    map_tryget(${root} next)
    ans(current)
    while(current)
      map_tryget(${current} value)
      ans(val)
      set(str "${str}${val}")

      map_tryget(${current} next)
      ans(current)
    endwhile()

    return_ref(str)
  endfunction()
