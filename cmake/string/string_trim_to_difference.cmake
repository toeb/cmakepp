## removes the beginning of the string that matches
## from ref lhs and ref rhs
function(string_trim_to_difference lhs rhs)
  string_overlap("${${lhs}}" "${${rhs}}")
  ans(overlap)
  string_take(${lhs} "${overlap}")
  string_take(${rhs} "${overlap}")
  set("${lhs}" "${${lhs}}" PARENT_SCOPE)
  set("${rhs}" "${${rhs}}" PARENT_SCOPE)
endfunction()
