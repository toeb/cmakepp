function(map_edit)
	# function for editing a map by console commands
	set(options
		--sort
		--insert
		--reverse
		--remove-duplicates
		--set
		--append
		--remove
		--reorder
		--print
	)

	cmake_parse_arguments("" "${options}" "" "" ${ARGN})
	
	list(GET _UNPARSED_ARGUMENTS 0 navigation_expression)
	list(REMOVE_AT _UNPARSED_ARGUMENTS 0)
	set(arg ${_UNPARSED_ARGUMENTS})


	map_transform( "${arg}")
	ans(arg)
	map_navigate(value "${navigation_expression}")
	list_isvalid("${value}" )
	ans(islist)
	set(result_list)
	if(islist)
		set(result_list "${value}")
		ref_get(${value} )
		ans(value)
	endif()


	if(_--remove)
		if(NOT arg)
			set(value )
		else()
			list(REMOVE_ITEM value "${arg}")
		endif()
	elseif(_--sort)
	elseif(_--reorder)

	elseif(_--insert)
		list(INSERT value "${arg}")
	elseif(_--reverse)
	elseif(_--remove-duplicates)
	elseif(_--set )
		set(value "${arg}")
	elseif(_--append)
		set(value "${value}" "${arg}")
	else()
		if(_--print)			
			ref_print(${value})
		endif()
		return()
	endif()



	# modifiers
	if(_--remove-duplicates)
		list(REMOVE_DUPLICATES value)
	endif()

	if(_--sort)
		list(SORT value)
	endif()

	if(_--reverse)
		list(REVERSE value)
	endif()
	

	list(LENGTH value len)
	if(${len} GREATER 1)
		if(NOT result_list)
			list_new()
			ans(result_list)
		endif()
		ref_set(${result_list} "${value}")	
		set(value ${result_list})
	endif()
	map_navigate_set("${navigation_expression}" "${value}")
	if(_--print)
		ref_print("${value}")
	endif()
endfunction()