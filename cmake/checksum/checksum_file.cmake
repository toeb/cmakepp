# calculates and returns the checksum for the specified file
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
function(checksum_file file)
  path("${file}")
  ans(path)
  
  set(args ${ARGN})
  list_extract(args checksum_alg)
  if(NOT checksum_alg)
    set(checksum_alg MD5)
  endif()
  file(${checksum_alg} "${file}" checksum)
  return_ref(checksum)
endfunction()


