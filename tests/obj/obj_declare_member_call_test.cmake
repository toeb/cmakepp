function(test)
  
  function(obj_declare_member_call obj function_ref) 
    function_new()
    ans(func)
    map_set_special(${obj} call_member ${func})
    set(${function_ref} ${func} PARENT_SCOPE)
  endfunction()
  function(this_declare_member_call function_ref)
    obj_declare_member_call(${this} _res)
    set(${function_ref} ${_res} PARENT_SCOPE)
  endfunction()

  function(TestClass)

    this_declare_member_call(membercall)
    function(${membercall} obj membername)
      return("${membername}(${ARGN})")
    endfunction()

  endfunction()

  new(TestClass)
  ans(uut)


  rcall(res = uut.asdasd(1 2 3))
  
  assert("${res}" EQUALS "asdasd(1;2;3)")



endfunction()