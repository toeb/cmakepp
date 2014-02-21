function(obj_create result)
 if(${ARGC} GREATER 1)
 	# custom object id
 	set(ref ${ARGV1})
 else()
 	random_file(ref "${cutil_data_dir}/objects/{{id}}")
 endif()
 
 #check if object exists
 obj_exists(objectExists ${ref})
 if(objectExists)
 	message(FATAL_ERROR "object '${ref}' already exists")
 endif()

 file(MAKE_DIRECTORY ${ref})

 return_value(${ref})
endfunction()