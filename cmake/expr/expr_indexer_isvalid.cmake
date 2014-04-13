

  function(expr_indexer_isvalid path)
    set(regex_indexer_expr ".*\\[.+\\]")
    if("${path}" MATCHES "^${regex_indexer_expr}$")
      return(true)
    endif()
    return(false)
  endfunction()