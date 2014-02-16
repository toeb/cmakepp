function(get_all result)
	subdirlist(dirs "${cutil_data_dir}/objects")
	return_value(${dirs})
endfunction()