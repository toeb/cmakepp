function(test)
  
  

  function(test_package_dependency_configuration_changeset lhs rhs)
    data("${lhs}")
    ans(lhs)
    data("${rhs}")
    ans(rhs)
    package_dependency_configuration_changeset(${lhs} ${rhs})
    return_ans()
  endfunction()


  define_test_function(test_uut test_package_dependency_configuration_changeset lhs rhs)


  test_uut("{}" "{}" "{}")
  test_uut("{a:'install'}" "{}" "{a:'true'}")
  test_uut("{a:'uninstall'}" "{}" "{a:'false'}")
  test_uut("{a:null}" "{a:'true'}" "{a:'true'}")
  test_uut("{a:'uninstall'}" "{a:'true'}" "{a:'false'}")
  test_uut("{a:'install'}" "{a:'false'}" "{a:'true'}")

endfunction()