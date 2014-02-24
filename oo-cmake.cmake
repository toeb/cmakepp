cmake_minimum_required(VERSION 2.8.12)

cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)

include(CMakeParseArguments)
if(NOT cutil_cache_dir)
set(cutil_cache_dir "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/cache")
endif()
if(NOT cutil_temp_dir)
set(cutil_temp_dir "${CMAKE_CURRENT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/tmp")
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
	foreach(export_expr ${package_cmake_exports})	
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