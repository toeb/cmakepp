function(test)



  cmake_invocation_argument_list_find("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^b($|\;)" )
  ans(res)
  assert(${res} EQUALS b bsd)

  cmake_invocation_argument_list_find("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^c($|\;)" )
  ans(res)
  assert(${res} EQUALS c csd)

  cmake_invocation_argument_list_find("set(a asd)\nset(b bsd)\nset(c csd)" "set" "^d($|\;)" )
  ans(res)
  assert(${res} ISNULL)


  cmake_invocation_argument_list_find("asd(a asd)\nbsd(b bsd)\ncsd(c csd)" "csd")
  ans(res)
  assert(${res} EQUALS c csd)

endfunction()