function(test)
  function(ThisBaseClass)
  endfunction()
  function(ThisOtherSubclass)
    this_inherit(ThisBaseClass)
  endfunction()
  function(ThisSubClass)
    this_inherit(ThisBaseClass)
    obj_new(other ThisOtherSubclass)
  endfunction()

  assert(INCONCLUSIVE)

endfunction()