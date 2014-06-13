
function(expr_string_isvalid str)

  set(regex_single_quote_string "'[^']*'")
  set(regex_double_quote_string "\"[^\"]*\"")
  set(regex_string "(${regex_single_quote_string}|${regex_double_quote_string})")
  if("${str}" MATCHES "^${regex_single_quote_string}$")
   return(true)
  endif()
  if("${str}" MATCHES "^(${regex_double_quote_string})$")
    return(true)
  endif()
  return(false)
endfunction()