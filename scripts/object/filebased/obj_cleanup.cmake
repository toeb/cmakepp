#removes the temporary objects created
# shoudl be called at end of cmake run
function(obj_cleanup)
	file(REMOVE_RECURSE "${cutil_temp_dir}/objects")
endfunction()