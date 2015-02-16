
  function(file_configure source_file target_file syntax)
    if("${syntax}" STREQUAL "@-syntax")
      configure_file("${source_file}" "${target_file}" @ONLY)
      return()
    endif()
    message(FATAL_ERROR "file_configure currently only implemented @-syntax")
  endfunction()