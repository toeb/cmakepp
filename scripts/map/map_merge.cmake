# merges all maps passed as ARGN into target maps
# if target 
# specify 
function(map_merge target)
	set(options UNION DIFFERENCE INPLACE )
  	set(oneValueArgs TARGET)
  	set(multiValueArgs)
  	set(prefix)
  	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  	#_UNPARSED_ARGUMENTS

endfunction()