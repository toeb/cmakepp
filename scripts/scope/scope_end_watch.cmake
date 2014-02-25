# you need to use this in conjunction with scope_watch_return_values
	function(scope_end_watch scope_end_watch_result)
		get_cmake_property(scope_end_watch_now VARIABLES)
		scope_peek(scope_end_watch_before)
		
		map_create(scope_end_watch_res)
		
		# remove uninteresting values
		list(REMOVE_ITEM 
			#local vars
			scope_end_watch_now 
			scope_end_watch_result
			scope_end_watch_res 
			scope_end_watch_before
			#hack
			cutil_current_working_dir 
			# function vars
			ARGN ARGV ARGC ARGV0 ARGV1 ARGV2 ARGV3 ARGV4 ARGV5 ARGV6 ARG7 ARGV8 ARGV9)


		foreach(var ${scope_end_watch_now})

			map_tryget(${scope_end_watch_before} beforeVal ${var})
			set( nowVal ${${var}})
			if(NOT "${beforeVal}" STREQUAL "${nowVal}")
				map_set(${scope_end_watch_res} ${var} "${nowVal}")
			endif()
		endforeach()
		scope_discard()
		set(${scope_end_watch_result} ${scope_end_watch_res} PARENT_SCOPE)

	endfunction()
