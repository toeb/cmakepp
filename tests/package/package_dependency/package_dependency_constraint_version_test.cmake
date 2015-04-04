function(test)

  package_dependency_problem_test(
    "{'A@*':{version:'>2.0.0'}}" 
    "package_dependency_constraint_semantic_version" 
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B"
  )
  ans(res)
  if(NOT "${res}" MATCHES "\\(!project:root|!mock:A\\)")
    assert(FAIL "unsuccessfull")
  endif()
  if(NOT "${res}" MATCHES "!mock:A@2\\.0\\.0")
    assert(FAIL "unsuccessfull")
  endif()
  if("${res}" MATCHES "!mock:A@3\\.0\\.0")
    assert(FAIL "unsuccessfull")
  endif()


  package_dependency_problem_test(
    "{'A@*':{version:'>=2.0.0'}}"
    "package_dependency_constraint_semantic_version" 
    "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  if(NOT "${res}" MATCHES "\\(!project:root|!mock:A\\)")
    assert(FAIL "unsuccessfull")
  endif()
  if("${res}" MATCHES "!mock:A@2\\.0\\.0")
    assert(FAIL "unsuccessfull")
  endif()
  if("${res}" MATCHES "!mock:A@3\\.0\\.0")
    assert(FAIL "unsuccessfull")
  endif()




  package_dependency_problem_test("{'A@*':'true'}"
    "package_dependency_constraint_semantic_version" 
   "A@1.0.0" "A@2.0.0" "A@3.0.0" "B")
  ans(res)
  assert(NOT "${res}" MATCHES "&")





endfunction()