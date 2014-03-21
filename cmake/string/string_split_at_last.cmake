  #splits string at last occurence of separator and retruns both parts
  function(string_split_at_last parta partb input separator)
    string(FIND "${input}" "${separator}" idx  REVERSE)
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