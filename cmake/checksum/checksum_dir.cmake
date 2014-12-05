# calculates and returns the checksum for the specified directory
# including file content
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
  function(checksum_dir dir)
    path("${dir}")
    ans(dir)

    set(args ${ARGN})
    list_extract(args checksum_alg)
    if(NOT checksum_alg)
      set(checksum_alg MD5)
    endif()

    file(GLOB_RECURSE files RELATIVE "${dir}" "${dir}/**")
    set(checksums)
    foreach(file ${files})
      checksum_file("${dir}/${file}" "${checksum_alg}")
      ans(file_checksum)
      checksum_string("${file}" "${checksum_alg}")
      ans(string_checksum)
      checksum_string("${file_checksum}${string_checksum}" "${checksum_alg}")
      ans(combined_checksum)
      list(APPEND checksums "${combined_checksum}")
    endforeach()

    checksum_string("${checksums}" "${checksum_alg}")
    ans(checksum_dir)
    return_ref(checksum_dir)
  endfunction()