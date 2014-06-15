function(list_extract_labelled_value lst label)
  list(LENGTH ${lst} len)
  if(NOT len)
    return()
  endif()

  list(FIND ${lst} "${label}" pos)
  message("found label ${label} at ${pos} in ${${lst}}")
  if("${pos}" LESS 0)
    return()
  endif()

  eval_math("${pos} + 2")
  ans(end)


  if(${end} GREATER ${len} )
    eval_math("${pos} + 1")
    ans(end)
  endif()

  list_erase_slice(${lst} ${pos} ${end})
  ans(vals)
  message("found flag ${label} val ${vals} rest: ${${lst}}")
  list_pop_front(vals)
  ans(flag)
    
  # special treatment for [] values
  if("_${vals}" MATCHES "^_\\[.*\\]$")
    string_slice("${vals}" 1 -2)
    ans(vals)
  endif()

  
  set(${lst} ${${lst}} PARENT_SCOPE)


  return_ref(vals)
endfunction()

