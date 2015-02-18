# creates a temporary file
function(file_make_temporary content)
  cmakepp_config(temp_dir)
  ans(temp_dir)
	file_random( "${temp_dir}/file_make_temporary_{{id}}.tmp")
  ans(rnd)
	file(WRITE ${rnd} "${content}")
  return_ref(rnd)
endfunction()


## 
## 
## creates a temporary file containing the specified content
## returns the path for that file 
## --pattern 
## --extension
## --dir
function(fwrite_temp content)
  message(FATAL_ERROR not implemented)
  set(args ${ARGN})
  list_extract_value(args --pattern)
  ans(pattern)

  if(NOT pattern)
    
    list_extract_value(args --extension)
    ans(ext)
    list_extract_value(args --dir)
    ans(dir)
    if(NOT ext)

  endif() 

return()
endfunction()