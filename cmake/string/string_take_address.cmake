
## string_take_address
##
## takes an address from the string ref  
function(string_take_address str_ref)
  string_take_regex("${str_ref}" ":[1-9][0-9]*")
  ans(res)
  set(${str_ref} ${${str_ref}} PARENT_SCOPE)   
  return_ref(res)
endfunction()
