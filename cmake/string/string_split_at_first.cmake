# splits input at first occurence of separator into part a  and partb
function(string_split_at_first parta partb input separator)
  string(FIND "${input}" "${separator}" idx )
  if(${idx} LESS 0)
    set(${parta} "${input}" PARENT_SCOPE)
    set(${partb} "" PARENT_SCOPE)
    return()
  endif()

  string(SUBSTRING "${input}" 0 ${idx} pa)
  math(EXPR idx "${idx} + 1")

  string(SUBSTRING "${input}" ${idx} -1 pb)
  set(${parta} ${pa} PARENT_SCOPE)
  set(${partb} ${pb} PARENT_SCOPE)
endfunction()