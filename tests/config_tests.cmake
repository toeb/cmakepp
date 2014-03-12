function(test)

	function(map_navigate_set path)
		# path is empty => ""
		if(navigation_expression STREQUAL "")
			return_value("")
		endif()

		# if navigation expression is a simple var just set return it
		if("${navigation_expression}")
			set(${navigation_expression} "${ARGN}")
			return()
		endif()

		# split off reference from navigation expression
		unset(ref)
		string(REGEX MATCH "^[^\\[|\\.]*" ref "${navigation_expression}")
		string(LENGTH "${ref}" len )
		string(SUBSTRING "${navigation_expression}" ${len} -1 navigation_expression )

		# if ref is a ref to a ref dereference it :D 
		if(DEFINED ${ref})
			set(ref ${${ref}})
		endif()

		# check if ref is valid
		ref_isvalid( ${ref} is_ref)
		if(NOT is_ref)
			message(FATAL_ERROR "map_navigate: expected a reference")
		endif()

		# match all navigation expression parts
		string(REGEX MATCHALL  "(\\[([0-9][0-9]*)\\])|(\\.[a-zA-Z0-9_\\-][a-zA-Z0-9_\\-]*)" parts "${navigation_expression}")
		
		# loop through parts and try to navigate 
		# if any part of the path is invalid return ""
		set(current "${ref}")
		foreach(part ${parts})
			string(REGEX MATCH "[a-zA-Z0-9_\\-][a-zA-Z0-9_\\-]*" index "${part}")
			string(SUBSTRING "${part}" 0 1 index_type)	
			if(index_type STREQUAL ".")
				# get by key
				map_tryget(${current} current "${index}")
			elseif(index_type STREQUAL "[")
				# get by index
				ref_get( ${current} lst)
				list(GET lst ${index} keyOrValue)
				map_tryget(${current} current ${keyOrValue})
				if(NOT current)
					set(current "${keyOrValue}")
				endif()
			endif()
			if(NOT current)
				return_value("")
			endif()
		endforeach()

		# current  contains the navigated value
		set(${result} "${current}" PARENT_SCOPE)
	endfunction()
	function(map_navigate_append path)

	endfunction()
	function(Configuration)
		proto_declarefunction(Write)
		function(${Write})

		endfunction()

		proto_declarefunction(Load)
		function(${Load})

		endfunction()

	endfunction()


 	function(config_write)

 	endfunction()


endfunction()