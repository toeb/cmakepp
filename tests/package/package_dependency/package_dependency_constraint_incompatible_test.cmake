function(test)


  package_dependency_problem_test(
    "{'A@*':{constraint_type:'incompatible'}}"
    "package_dependency_constraint_incompatible" 
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("${res}" MATCHES  "\\(!project:root|!mock:A@2\\.0\\.0\\)")


  package_dependency_problem_test(
    "{A@*:''}"
    "package_dependency_constraint_incompatible" 
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("_${res}_" STREQUAL "_()_")


endfunction()