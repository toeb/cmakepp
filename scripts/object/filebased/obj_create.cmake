#usage
# obj_create(result:<ref> [TRANSIENT(default)|PERSISTENT] NAMED)
# transient objects are deleted when cmake closes NAMED is optional at the moment

function(obj_create result)
	set(options TRANSIENT PERSISTENT)
	set(oneValueArgs NAMED)
	set(multiValueArgs)
	set(prefix)
	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	


	if(_UNPARSED_ARGUMENTS)
 		# custom object id
 		list(GET _UNPARSED_ARGUMENTS 0 ref)
 	else()
 		if(_TRANSIENT OR NOT _PERSISTENT)
			random_file(ref "${cutil_temp_dir}/objects/object_{{id}}")
 		else() 			
			random_file(ref "${cutil_temp_dir}/objects/object_{{id}}")
 		endif()


 	endif()
 
 	#check if object exists
 	obj_exists(objectExists ${ref})
 	if(objectExists)
 		message(FATAL_ERROR "object '${ref}' already exists")
 	endif()

	file(MAKE_DIRECTORY ${ref})

	

 	return_value(${ref})
endfunction()