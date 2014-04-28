# remove match from in out var ${${str_name}}
# returns match
function(string_take str_name match)
  string(FIND "${${str_name}}" "${match}" index)
  #message("trying to tak ${match}")
  if(NOT ${index} EQUAL 0)
    return()
  endif()
  #message("took ${match}")
  string(LENGTH "${match}" len)
  string(SUBSTRING "${${str_name}}" ${len} -1 rest )
  set("${str_name}" "${rest}" PARENT_SCOPE)


  return_ref(match)
 
endfunction()