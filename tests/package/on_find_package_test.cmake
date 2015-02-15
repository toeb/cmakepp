function(test)

  event_clear(on_find_package)

  map_new()
  ans(context)



  event_addhandler(on_find_package "[](a) map_append(${context} find_package {{a}})")

  function(test_handler_findpackage)
    if("${ARGN}_" STREQUAL "asdasd_")
      set(res)
      assign(!res.valA = '1')
      assign(!res.valB = '2')
      map_set_hidden(${res} find_package_return_value "huhu")
      event_cancel()
      return_ref(res)
    endif()
    return()
  endfunction()



  event_addhandler(on_find_package "test_handler_findpackage")
  event_addhandler(on_find_package "[](a) map_append(${context} find_package_after {{a}})")


  ## default handler
  find_package(Hg)
  ans(res)
  assert(NOT res)

  assertf({context.find_package} STREQUAL "Hg")
  assertf({context.find_package_after} STREQUAL "Hg")


  event_clear(on_find_package)
  event_addhandler(on_find_package "test_handler_findpackage")
  

  map_set(${context} find_package)
  map_set(${context} find_package_after)

  ## cmakepp handler
  find_package(asdasd)
  ans(res)
  assert(res)
  assert("${res}" STREQUAL "huhu")



endfunction()