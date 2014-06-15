
# transforms a path to a path relative to base_dir
function(path_relative base_dir path)
  path(${base_dir})
  ans(base_dir)
  path(${path})
  ans(path)
  string_take(path "${base_dir}")
  return_ref(path)
endfunction()
