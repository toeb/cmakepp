# calculates and returns the checksum for the specified directory
# including file content
# uses md5 as a default, other algorithms are possible (see string or file for algorithm names)
  function(checksum_dir dir)
    set(args ${ARGN})
    list_extract_labelled_keyvalue(args --algorithm)
    ans(algorithm)

    path("${dir}")
    ans(dir)

    file(GLOB_RECURSE files RELATIVE "${dir}" "${dir}/**")

    checksum_files("${dir}" ${files} ${algorithm})
    return_ans()
  endfunction()
