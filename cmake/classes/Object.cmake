function(Object)
	#formats the current object 
	obj_declarefunction(${__proto__} to_string)

	function(${to_string} result)
		set(res)
#		debug_message("to_string object ${this}")
		obj_getkeys(${this} keys)

		foreach(key ${keys})
			obj_get(${this} value ${key})				
			obj_hasownproperty(${this} is_own ${key})	
			if(value)
				is_function(function_found ${value})
				is_object(object_found ${value})
			endif()
			
			
			if(function_found)
				set(value "[function]")
			elseif(object_found)
				get_filename_component(fn ${value} NAME_WE)
				obj_gettype(${value} type)
				if(NOT type)
					set(type "")
				endif()
				set(value "[object ${type}:${fn}]")
			else()
				set(value "\"${value}\"")
			endif()
			if(is_own)
				set(is_own "*")
			else()
				set(is_own " ")
			endif()

			set(nextValue "${is_own}${key}: ${value}")

			if(res)
				set(res "${res}\n ${nextValue}, ")	
			else()
				set(res " ${nextValue}, ")
			endif()
		endforeach()

		set(res "{\n${res}\n}")
		return_value(${res})
	endfunction()

	# prints the current object to the console
	obj_declarefunction(${__proto__} print)
	function(${print})
		#debug_message("printing object ${this}")
		obj_callmember(${this} "to_string" str )
		message("${str}")
	endfunction()
endfunction()


