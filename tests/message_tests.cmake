function(test)

  # test for listeners
  message(ADD_LISTENER listener)
  assert(listener)
  ref_isvalid(${listener} isvalid)
  assert(isvalid)

  message("hello")

  ref_get(${listener} msgs)
  assert(EQUALS ${msgs} "hello")

  message(REMOVE_LISTENER ${listener})

  message("hello")


  ref_get(${listener} msgs)
  assert(EQUALS ${msgs} "hello")


endfunction()