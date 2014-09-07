
# creates a temporary file with a specific extension
function(file_tmp extension content)
  oocmake_config(temp_dir)
  ans(temp_dir)
  file_random( "${temp_dir}/file_make_temporary_{{id}}.${extension}")
  ans(rnd)
  file(WRITE ${rnd} "${content}")
  return_ref(rnd)
endfunction()
