# retuns the extension of the specified file
function(file_extension path)
  path("${path}")
  ans(path)
  get_filename_component(res "${path}" EXT)
  return_ref(res)  
endfunction()