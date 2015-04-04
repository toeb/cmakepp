function(test)


  package_dependency_problem_test(
    "{'A@*':{constraint_type:'false'}}"
    "package_dependency_constraint_required"
     "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert("_${res}_" STREQUAL "_()_")


  package_dependency_problem_test(
    "{'A@*':{constraint_type:'required'}}" 
    "package_dependency_constraint_required"
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  if(NOT "${res}" MATCHES "\\(!project:root|mock:A|mock:A@2\\.0\\.0|mock:A@3\\.0\\.0\\)")
    assert(FAIL "unsuccessfull")
  endif()

endfunction()