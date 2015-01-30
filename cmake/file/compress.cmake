# compresses all files specified in glob expressions (relative to pwd) into ${target_file} tgz file
# usage: compress(<file> [<glob> ...]) - 
# 
function(compress target_file)
  set(args ${ARGN})
  
  list_extract_labelled_value(args --format)
  ans(format)

  ## try to resolve format by extension
  if(format STREQUAL "")
    get_filename_component(extension "${target_file}" EXT)    
    mime_type_from_extension("${extension}")
    ans(format)
  endif()

  ## set default formt to application/x-gzip
  if(format STREQUAL "")
    set(format "application/x-gzip")
  endif()

  if(format STREQUAL "application/x-gzip")
    compress_tgz("${target_file}" ${args})
    return_ans()
  else()
    message(FATAL_ERROR "format not supported: ${format}")
  endif()
endfunction()


