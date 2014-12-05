# returns the the parts of the string that overlap
# e.g. string_overlap(abcde abasd) returns ab
function(string_overlap lhs rhs)
  string(LENGTH "${lhs}" lhs_length)
  string(LENGTH "${rhs}" rhs_length)

  math_min("${lhs_length}" "${rhs_length}")
  ans(len)



  math(EXPR last "${len}-1")

  set(result)

  foreach(i RANGE 0 ${last})
    string_char_at(${i} "${lhs}")
    ans(l)
    string_char_at(${i} "${rhs}")
    ans(r)
    if("${l}" STREQUAL "${r}")
      set(result "${result}${l}")
    else()
      break()
    endif()
  endforeach()
  return_ref(result)

endfunction()
