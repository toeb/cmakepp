
function(file_directory_isempty result directory)
  file(GLOB files "${directory}/*" )
  if(files)
    return_value(false)
  endif()
  return_value(true)
endfunction()