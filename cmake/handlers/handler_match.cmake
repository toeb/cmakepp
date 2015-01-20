


  function(handler_match handler request)
    map_tryget(${handler} labels)
    ans(labels)

    map_tryget(${request} input)
    ans(input)

    list_pop_front(input)
    ans(cmd)


    list_contains(labels "${cmd}")
    ans(is_match)
    #print_vars(is_match labels input  request cmd)

    return_ref(is_match)
  endfunction()