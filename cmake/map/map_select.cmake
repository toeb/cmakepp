function(map_select result query)
# select something from a list 
# using syntax 'from a in lstA, b in lstB select {a.k1}{b.k1}'
# see map_transform and map_foreach
	string(REGEX REPLACE "from(.*)select(.*)" "\\1" _foreach_args "${query}")
	string(REGEX REPLACE "from(.*)select (.*)" "\\2" _select_args "${query}")

	list_new(_result_list)
	function(_map_select_foreach_action)
		map_transform(res "${_select_args}")
		ref_append(${_result_list} "${res}")
	endfunction()
	map_foreach( _map_select_foreach_action "${_foreach_args}")
	ref_get( ${_result_list} )
	ans(_result_list)
	set(${result} ${_result_list} PARENT_SCOPE)
endfunction()