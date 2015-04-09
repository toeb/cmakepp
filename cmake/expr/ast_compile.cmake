

function(ast_compile ast)
  map_tryget("${ast}" const)
  ans(is_const)
  
  map_tryget("${ast}" pure_value)
  ans(is_pure_value)

  if(is_pure_value)
    return()
  endif()

  set(code)

  map_tryget("${ast}" children)
  ans(children)
  foreach(child ${children})
    ast_compile("${child}")
    ans(child_code)

    set(code "${code}${child_code}")
  endforeach()

  map_tryget("${ast}" code)
  ans(current_code)
  
  set(code "${code}${current_code}")
  return_ref(code)
endfunction()

