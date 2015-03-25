function(test)


  package_dependency_problem_test(
    "{'A@*':{constraint_type:'optional'}}"
    "package_dependency_constraint_optional"
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("_${res}_" STREQUAL  "_()_")


  package_dependency_problem_test(
    "{'A@*':{constraint_type:'required'}}"
    "package_dependency_constraint_optional"
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("_${res}_" STREQUAL  "_()_")



endfunction()