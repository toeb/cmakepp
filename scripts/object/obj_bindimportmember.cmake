# bind  member function to ${object} and imports it as function(${targetname})
# all arguments behind targetname are passed along to import_function
# this allows flags such as REDEFINE and ONCE to be defined
function(obj_bindimportmember object member_to_bind targetname)
	obj_getref(${object} func ${member_to_bind})
	obj_bind(result ${object} ${func})
	import_function("${result}" as "${targetname}" ${ARGN})
endfunction()