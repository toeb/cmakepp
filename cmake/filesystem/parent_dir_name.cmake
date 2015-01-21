
function(parent_dir_name)
  path("${ARGN}")
  ans(path)
  path_component("${path}" --file-name-ext)
  return_ans()
endfunction()