

function(ast_compile ast)
  set(code)

  map_tryget("${ast}" children)
  ans(children)
  foreach(child ${children})
    ast_compile("${children}")
    ans(child_code)


    set(code "${code}${child_code}")

  endforeach()

  print_vars(ast)
  map_tryget("${ast}" code)
  ans(current_code)
  set(code "${code}${current_code}")


  return_ref(code)
endfunction()

