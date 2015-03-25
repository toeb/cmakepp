function(test)


  package_dependency_problem_test(
    "{'A@*':{mutually_exclusive:'true'}}"
    "package_dependency_constraint_mutually_exclusive" 
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("${res}" MATCHES  "\\(!mock:A|!mock:A@2\\.0\\.0\\)")
  assert("${res}" MATCHES  "\\(!mock:A|!mock:A@3\\.0\\.0\\)")
  assert("${res}" MATCHES  "\\(!mock:A@2\\.0\\.0|!mock:A@3\\.0\\.0\\)")





endfunction()