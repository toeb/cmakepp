
## `(<package handle> <content_dir: <path>>)-><bool>`
## checks to see if the package content is valid at the specified locatin
## returns true if so else returns false
function(package_content_check package_handle content_dir)
  path_qualify(content_dir)
  if(NOT EXISTS "${content_dir}")
    return(false)
  endif()
  return(true)
endfunction()