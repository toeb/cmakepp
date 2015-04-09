function(test)

  set(exception "{'__$type__':'exception'}")


  


return()
  define_test_function2(test_uut expr_eval "interpret_assign" "")
 # event_addhandler(on_exception "[](ex) print_vars(ex)")
  
  test_uut("<{b:1}>1" "$['b'] = 1")
return()

  test_uut("<{a:1}>1" "$a = 1")
  test_uut("<{a:2}>2" "$a = 2")
  test_uut("<{a:'abc'}>abc" "$a = abc")
  test_uut("<{a:'abc'}>abc" "$a = 'abc'")
  test_uut("<{a:'abc'}>abc" "$a = \"abc\"")



  return()


  #event_addhandler(on_exception "[](ex) print_vars(ex)")

  define_test_function2(test_uut expr "interpret_assign" "--ast")


  ## no tokens
  test_uut("${exception}")
  ## wrong tokens
  test_uut("${exception}" 1 2 3)
  ## missing tokens
  test_uut("${exception}" "=")
  ## missing lhs
  test_uut("${exception}" "=1")
  ## missing rhs
  test_uut("${exception}" "$a=")
  ## invalid lvalue
  test_uut("${exception}" "a=b")
  ## invalid rvalue
  test_uut("${exception}" "$a=,")







endfunction()