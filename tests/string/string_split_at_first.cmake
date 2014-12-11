function(test)

  string_split_at_first(partA partB "asdf@bsdf@csdf" "@")
  assert("${partA}" STREQUAL "asdf")
  assert("${partB}" STREQUAL "bsdf@csdf")

  string_split_at_first(partA partB "nothingtosplit" "@")
  assert("${partA}" STREQUAL "nothingtosplit")
  assert(NOT partB)

  string_split_at_first(partA partB "@splitatbeginning" "@")
  assert(NOT partA)
  assert("${partB}" STREQUAL "splitatbeginning")

  string_split_at_first(partA partB "splitatend@" "@")
  assert("${partA}" STREQUAL "splitatend")
  assert(NOT partB)
 

endfunction()