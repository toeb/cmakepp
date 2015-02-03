function(test)



  function(glob_expression)
    set(args ${ARGN})

    map_isvalid("${args}")
    ans(ismap)
    if(ismap)
      return_ref(args)
    endif()


    set(excludes)
    while(true)
      list_extract_labelled_value(args --exclude)
      ans(exclude)
      if(exclude STREQUAL "")
        break()
      endif()
      list(APPEND excludes ${exclude})
    endwhile()


    set(includes)
    while(true)
      list_extract_labelled_value(args --include)
      ans(include)
      if(include STREQUAL "")
        break()
      endif()
      list(APPEND includes ${include})
    endwhile()


    list_split_at(incs excs args --excludes)

    list(APPEND includes ${incs})
    list(APPEND excludes ${excs})

    map_new()
    ans(result)
    map_set(${result} include ${includes})
    map_set(${result} exclude ${excludes})

    return_ref(result)
  endfunction()


  glob_expression(asd.*)
  ans(res)
  assertf({res.include} STREQUAL "asd.*")
  assertf( "{res.exclude}_" STREQUAL "_")

  glob_expression(asd bsd)
  ans(res)
  assertf({res.include} EQUALS asd bsd)
  assertf( "{res.exclude}_" STREQUAL "_")

  glob_expression(asd bsd --exclude csd --exclude dsd)
  ans(res)
  assertf({res.include} EQUALS asd bsd)
  assertf({res.exclude} EQUALS csd dsd)


  glob_expression(asd --exclude csd bsd --exclude dsd)
  ans(res)
  assertf({res.include} EQUALS asd bsd)
  assertf({res.exclude} EQUALS csd dsd)


  glob_expression(asd --excludes csd bsd --exclude dsd)
  ans(res)
  assertf({res.include} EQUALS asd)
  assertf({res.exclude} EQUALS csd bsd dsd)




return()

  ## cp_glob(<glob. ..> <target dir>)-> <path...>
  function(cp_glob)



  endfunction()

endfunction()