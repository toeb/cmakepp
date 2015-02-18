function(test)


  event_clear(on_find_package)


  function(cmakepp_on_find_package_handler)
    set(input ${ARGN})
    message("input ${input}")
    string_take_delimited(input ' ')
    ans(package_query)

    ## only a single delimited string is allowed
    if("${package_query}_" STREQUAL "_")
      return()
    endif()


    message("lookgin for ${package_query}")
    # pull package if it does not exist 
    # then parse 

    event_cancel()
    set(res)
    assign(!res.TEST_REPO_HG_FOUND = 'true')
    map_set_hidden(${res}  find_package_return_value true)

    return_ref(res)
  endfunction()

  event_addhandler(on_find_package cmakepp_on_find_package_handler)




  find_package('toeb/test_repo_hg')
  ans(res)
  assert(res)

  assert(TEST_REPO_HG_FOUND)

endfunction()