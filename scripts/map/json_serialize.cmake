function(json_serialize result value)
	# set indented to true if result should be formatted
	
	set(indented false)
	set(indent)
	if(ARGN)
		set(args ${ARGN})
		list(FIND args "INDENTED" idx)
		if(NOT ${idx} LESS 0)
			set(indented true)
			set(indent INDENTED)
		endif()	
	endif()


	# increase level for indent
	if(__json_serialize_level)
		math(EXPR __json_serialize_level "${__json_serialize_level} + 1")			
	else()
		set(__json_serialize_level 0)
	endif()


	set(indentation "")
	if(indented)
		set(indentation_spacing "  ")
		set(indentation)
		foreach(i RANGE ${__json_serialize_level})
			set(indentation_less "${indentation}")
			set(indentation "${indentation}${indentation_spacing}")
		endforeach()
		set(separator ",\n${indentation}")
		string(LENGTH "${separator}" separator_length)
		
	else()
		set(separator ",")
		set(separator_length 1)
	endif()


	# if value is empty return an empty string
	if(NOT value)
		set(${result} PARENT_SCOPE)
		return()
	endif()
	# if value is a not ref return a simple string value
	ref_isvalid(${value} is_ref)
	if(NOT is_ref)
		set(${result} "\"${value}\"" PARENT_SCOPE)
		return()
	endif()


	# get ref type
	# here map, list and * will be differantited
	# resulting object, array and string respectively
	ref_gettype(${value} ref_type)
	if(${ref_type} STREQUAL map)
		set(res)
		map_keys(${value} keys)

		foreach(key ${keys})
			map_get(${value} val ${key})			
			json_serialize(serialized_value "${val}" ${indent})				
			set(res "${res}${separator}\"${key}\":${serialized_value}")
		endforeach()
		string(LENGTH "${res}" len)
		if(${len} GREATER 0)
			string(SUBSTRING "${res}" ${separator_length} -1 res)
		endif()
		if(indented)
			set(res "{\n${indentation}${res}\n${indentation_less}}")
		else()
			set(res "{${res}}")
		endif()
		set(${result} "${res}" PARENT_SCOPE )
		return()
	elseif(${ref_type} STREQUAL list)
		ref_get( ${value} lst)
		set(res "")
		foreach(val ${lst})
			json_serialize(serialized_value "${val}" ${indent})
			set(res "${res}${separator}${serialized_value}")				
		endforeach()	

		string(LENGTH "${res}" len)
		if(${len} GREATER 0)				
			string(SUBSTRING "${res}" ${separator_length} -1  res)
		endif()
	
		if(indented)
			set(res "[\n${indentation}${res}\n${indentation_less}]")
		else()
			set(res "[${res}]")
		endif()
		
		set(${result} ${res} PARENT_SCOPE)
		return()
	else()			
		ref_get( ${value} ref_value)
		set(${result} "\"${ref_value}\"" PARENT_SCOPE)
		return()
	endif()
endfunction()