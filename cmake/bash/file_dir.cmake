# returns the directory of the specified file
function(file_dir path)
  path("${path}")
  ans(path)
  get_filename_component(res "${path}" PATH)
  return_ref(res)
endfunction()