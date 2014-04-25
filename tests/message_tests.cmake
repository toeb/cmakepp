function(test)

  # test for listeners
  message(ADD_LISTENER listener)
  assert(listener)
  ref_isvalid(${listener} )
  ans(isvalid)
  assert(isvalid)

  message("hello")

  ref_get(${listener} )
  ans(msgs)
  map_tryget(global message_listeners)
  ans(message_listeners)

  assert(EQUALS ${msgs} "hello")

  message(REMOVE_LISTENER ${listener})

  message("hello")


  ref_get(${listener} )
  ans(msgs)
  assert(EQUALS ${msgs} "hello")


endfunction()