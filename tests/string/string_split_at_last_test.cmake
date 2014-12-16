function(test)
  string_split_at_last(partA partB "asdf@bsdf@csdf" "@")
  assert("${partA}" STREQUAL "asdf@bsdf")
  assert("${partB}" STREQUAL "csdf")

  string_split_at_last(partA partB "nothingtosplit" "@")
  assert("${partA}" STREQUAL "nothingtosplit")
  assert(NOT partB)

  string_split_at_last(partA partB "@splitatbeginning" "@")
  assert(NOT partA)
  assert("${partB}" STREQUAL "splitatbeginning")

  string_split_at_last(partA partB "splitatend@" "@")
  assert("${partA}" STREQUAL "splitatend")
  assert(NOT partB)

endfunction()