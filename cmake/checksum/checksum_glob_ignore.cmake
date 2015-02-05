

  function(checksum_glob_ignore)
    set(args ${ARGN})
    list_extract_labelled_keyvalue(args --algorithm)
    ans(algorithm)
    glob_ignore(${args} --relative --recurse ${algorithm})
    ans(files)



    pwd()
    ans(pwd)

    checksum_files("${pwd}" ${files})
    return_ans()
  endfunction()