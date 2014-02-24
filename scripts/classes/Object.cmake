function(Object)
	#formats the current object
	obj_declarefunction(${__proto__} to_string)
	function(${to_string} result)
		debug_message("to_string object ${this}")
			obj_getkeys(${this} keys)

			foreach(key ${keys})
				obj_get(${this} value ${key})
				
				if(value)
					is_function(function_found ${value})
					is_object(object_found ${value})
				endif()
				
				
				if(function_found)
					set(value "[function]")
				elseif(object_found)
					set(value "[object ${value}]")
				else()
					set(value "\"${value}\"")
				endif()


				if(res)
					set(res "${res}\n ${key}: ${value}, ")	
				else()
					set(res " ${key}: ${value}, ")
				endif()
			endforeach()

			set(res "{\n${res}\n}")
			return_value(${res})
	endfunction()

	# prints the current object to the console
	obj_declarefunction(${__proto__} print)
	function(${print})
		debug_message("printing object ${this}")
		obj_callmember(${this} "to_string" str )
		message("${str}")
	endfunction()
endfunction()
