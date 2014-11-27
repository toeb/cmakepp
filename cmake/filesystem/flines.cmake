# reads the file specified and returns its content
function(flines path)
  path("${path}")
  ans(path)
  file(STRINGS "${path}" res)
  return_ref(res)
endfunction()