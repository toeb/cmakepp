# calculates and returns the checksum for the specified file
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
function(checksum_file file)

  path_qualify(file)


  set(args ${ARGN})
  list_extract_labelled_value(args --algorithm)
  ans(checksum_alg)
  if(NOT checksum_alg)
    set(checksum_alg MD5)
  endif()
  file(${checksum_alg} "${file}" checksum)
  return_ref(checksum)
endfunction()


