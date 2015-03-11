function(test)
  function(test_package_handle_update_dependencies)
    set(args ${ARGN})
    
    map_new()
    ans(package_handle)
    
    while(true)
      list_extract_labelled_value(args --before)
      ans(res)
      if(NOT res)
        break()
      endif()    
      package_handle_update_dependencies(${package_handle} ${res})
    endwhile()

    package_handle_update_dependencies(${package_handle} ${args})
    ans(diff)
    map_tryget(${package_handle} package_descriptor)
    map_tryget(${__ans} dependencies)
    ans(dependencies)

    map_capture_new(dependencies diff)
    ans(result)
    return_ref(result)
  endfunction()


  define_test_function(test_uut test_package_handle_update_dependencies)
    
  test_uut("{dependencies:{A:{asd:'gaga'}, B:'true'}}" "A {asd:'gaga'}" B )

  test_uut("{dependencies:{A:'true'}}" --before "A")
  test_uut("{dependencies:{A:null}, diff:{A:'true'}}" "A remove" --before "A")
  test_uut("{dependencies:{}}")
  test_uut("{dependencies:{A:'true'}}" A)
  test_uut("{dependencies:{A:'false'}}" "A conflict")
  test_uut("{dependencies:{A:null}}" "A optional")
  test_uut("{dependencies:{A:'true',B:'true'}}" A B)
  test_uut("{dependencies:{A:'false', B:'true'}}" "A conflict" B )

endfunction()
