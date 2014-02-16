

# Converts a CMake list to a string containing elements separated by spaces
function(list_to_string result_name list_name separator )
  set(result)
  set(current_separator)
  foreach(element ${${list_name}})
    set(result "${result}${current_separator}${element}")
    # after first iteration separator will be set correctly
    # so i do not need to remove initial separator afterwords
    set(current_separator ${separator})
  endforeach()

  set(${result_name} "${result}" PARENT_SCOPE)
endfunction()