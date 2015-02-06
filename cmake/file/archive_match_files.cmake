
function(archive_match_files archive regex)
  set(args ${ARGN})

  list_extract_flag(args --single)
  ans(single)
  list_extract_flag(args --first)
  ans(first)

  path_qualify(archive)

  mime_type("${archive}")
  ans(types)


  if("${types}" MATCHES "application/x-gzip")

    archive_ls("${archive}")
    ans(files)

    list_regex_match(files "${regex}")
    ans(files)


  else()
    message(FATAL_ERROR "${archive} unsupported compression: '${types}'")
  endif()

  if(single)
    list(LENGTH files len)
    if(NOT "${len}" EQUAL 1)
      set(files)
    endif()
  endif()

  if(first)
    list_pop_front(files)
    ans(files)
  endif()


  return_ref(files)
endfunction()