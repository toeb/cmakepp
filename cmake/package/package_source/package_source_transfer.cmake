function(package_source_transfer)
  if("${ARGN}" MATCHES "(.*)=>(.*)")
    set(source_args ${CMAKE_MATCH_1})
    set(sink_args ${CMAKE_MATCH_2})
  else()
    message(FATAL_ERROR "invalid arguments. expcted <source> <source args> => <sink> <sink args>")
  endif()
  list_pop_front(source_args)
  ans(source)

  list_pop_front(sink_args)
  ans(sink)

  assign(package_handle = sink.push(${source} ${source_args} => ${sink_args}))
    
  return_ref(package_handle)
endfunction()
