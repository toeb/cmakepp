function(test)



  cmake_get_arguments_list("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^b($|\;)" )
  ans(res)
  assert(${res} EQUALS b bsd)

  cmake_get_arguments_list("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^c($|\;)" )
  ans(res)
  assert(${res} EQUALS c csd)

  cmake_get_arguments_list("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^d($|\;)" )
  ans(res)
  assert(${res} ISNULL)


  cmake_get_arguments_list("asd(a asd)\nbsd(b bsd)\ncsd(c csd)" "csd")
  ans(res)
  assert(${res} EQUALS c csd)

endfunction()