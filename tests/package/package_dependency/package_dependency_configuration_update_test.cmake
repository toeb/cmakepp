function(test)

  mock_package_source("mock"
    A B
    "A=>B"

    )
  ans(package_source)

  function(test_package_dependency_configuration_update)
    set(args ${ARGN})


    map_new()
    ans(package_handle)
    map_set(${package_handle} uri "project:root")

    while(true)
      list_extract_labelled_value(args --init)
      ans(init)
      if(NOT init)
        break()
      endif()
      package_dependency_configuration_update(
        ${package_source} 
        ${package_handle}
        ${init}
      )      
    endwhile()
    
    package_dependency_configuration_update(
      ${package_source} 
      ${package_handle}
      ${args}
      )  
    ans(result)
    json_print(${result})
    return_ref(result)
  endfunction()

  define_test_function(test_uut test_package_dependency_configuration_update)

  test_uut("{'mock:A':'true', 'mock:B':'true'}" A)
  test_uut("{'mock:A':'true', 'mock:B':'true'}" "A {asd:'123'}")
endfunction()
