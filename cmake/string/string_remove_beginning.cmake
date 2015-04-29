## `(<original:<string>> <beginning:<string>>)-><original:<string>>`
##
## Removes the beginning "n"-chars of the string "original".
## Number of chars "n" is calculated based on string "beginning".
##
## **Examples**
##  set(input "abc")
##  string_remove_ending("${input}" "a") # => "ab"
##  string_remove_ending("${input}" "ab") # => "a"
##
##
function(string_remove_beginning original beginning)
  string(LENGTH "${beginning}" len)
  string(SUBSTRING "${original}" ${len} -1 original)

  return_ref(original)
endfunction()