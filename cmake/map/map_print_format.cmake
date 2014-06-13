function(map_print_format)
	map_format( "${ARGN}")
  ans(res)
	message("${res}")

endfunction()