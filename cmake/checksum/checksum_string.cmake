# calculates and returns the checksum for the specified string
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
function(checksum_string str)
  set(args ${ARGN})
  list_extract_labelled_value(args --algorithm)
  ans(algorithm)
  if(NOT algorithm)
    set(algorithm MD5)
  endif()

  string("${algorithm}"  checksum "${str}" )
  return_ref(checksum)
endfunction()