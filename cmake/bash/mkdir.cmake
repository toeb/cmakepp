# creates a new directory
function(mkdir path)
  path("${path}")
  ans(path)
  file(MAKE_DIRECTORY "${path}")
  return_ref(path)
endfunction()