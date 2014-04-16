cmake_minimum_required(VERSION 2.8.7)

cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)

set_property(GLOBAL PROPERTY __global_ref_count 0)

#todo put this somewhere else...
function(function_called name caller)
	get_property(count GLOBAL PROPERTY "call_count_${name}")
	if(NOT count)
		set_property(GLOBAL  APPEND PROPERTY "function_calls" "${name}")
		set(count "0")
	endif()
	math(EXPR count "${count} + 1")
	set_property(GLOBAL PROPERTY "call_count_${name}" "${count}")	
	set_property(GLOBAL APPEND PROPERTY  "call_count_${name}_caller" "${caller}")
endfunction()


include(CMakeParseArguments)
if(NOT cutil_cache_dir)
set(cutil_cache_dir "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/cache")
endif()
if(NOT cutil_temp_dir)
set(cutil_temp_dir "${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/tmp")
endif()
function(load_oocmake)
	function(package_property name)
		set("${name}" "${ARGN}" PARENT_SCOPE)
	endfunction()
	include("${CMAKE_CURRENT_LIST_DIR}/package.cmake")
	
	function (import_function function_path)
		include("${function_path}")
	endfunction()
	set(all_functions)
	foreach(export_expr ${cmake_exports})	
		file(GLOB exported_functions "${CMAKE_CURRENT_LIST_DIR}/${export_expr}")
		foreach(exported_function "${exported_functions}")
			set(all_functions ${all_functions} ${exported_function})
		endforeach()
	endforeach()
	
	
	list(REMOVE_DUPLICATES all_functions)
	
	foreach(exported_function ${all_functions})
		if(NOT IS_DIRECTORY "${exported_function}")
			#message(STATUS "importing ${exported_function}")
 			import_function("${exported_function}" REDEFINE )
		endif()
	endforeach()

endfunction()
load_oocmake()