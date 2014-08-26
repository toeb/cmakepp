# creates a temporary file
function(file_make_temporary content)
  oocmake_config(temp_dir)
  ans(temp_dir)
	file_random( "${temp_dir}/file_make_temporary_{{id}}.tmp")
  ans(rnd)
	file(WRITE ${rnd} "${content}")
  return_ref(rnd)
endfunction()


# creates a temporary file
function(file_tmp extension content)
  oocmake_config(temp_dir)
  ans(temp_dir)
  file_random( "${temp_dir}/file_make_temporary_{{id}}.${extension}")
  ans(rnd)
  file(WRITE ${rnd} "${content}")
  return_ref(rnd)
endfunction()


