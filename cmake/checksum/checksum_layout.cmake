# calculates and returns the checksum for the specified directory
# without checking files themselves
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
  function(checksum_layout dir)
    path("${dir}")
    ans(dir)

    set(args ${ARGN})
    
    list_extract_labelled_keyvalue(args --algorithm)
    ans(algorithm)


    file(GLOB_RECURSE files RELATIVE "${dir}" "${dir}/**")

    checksum_string("${files}" ${algorithm})
    ans(checksum_dir)

    return_ref(checksum_dir)
  endfunction()

