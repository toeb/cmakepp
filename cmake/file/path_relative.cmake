
# transforms a path to a path relative to base_dir
function(path_relative base_dir path)
  path("${base_dir}")
  ans(base_dir)
  path("${path}")
  ans(path)
  string_take(path "${base_dir}")

  if("${path}" MATCHES "^\\/")
    string_substring("${path}" 1)
    ans(path)
  endif()

  return_ref(path)
endfunction()
