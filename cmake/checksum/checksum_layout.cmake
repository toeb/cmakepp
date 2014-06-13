# calculates and returns the checksum for the specified directory
# without checking files themselves
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
  function(checksum_layout dir)
    get_filename_component(dir "${dir}" REALPATH)
    set(args ${ARGN})
    list_extract(args checksum_alg)
    if(NOT checksum_alg)
      set(checksum_alg MD5)
    endif()

    file(GLOB_RECURSE files RELATIVE "${dir}" "${dir}/**")
    checksum_string("${files}" "${checksum_alg}")
    ans(checksum_dir)

    return_ref(checksum_dir)
  endfunction()