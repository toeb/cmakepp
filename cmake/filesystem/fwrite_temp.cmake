
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