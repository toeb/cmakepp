## cmakepp 
##
## An enhancement suite for CMake
## 
##
## This file is the entry point for cmakepp. If you want to use the functions 
## just include this file.
##
## it can also be used as a module file with cmake's find_package() 


cmake_minimum_required(VERSION 2.8.7)

get_property(is_included GLOBAL PROPERTY oocmake_include_guard)
if(is_included)
  _return()
endif()
set_property(GLOBAL PROPERTY oocmake_include_guard true)


cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)
if(POLICY CMP0054)
  cmake_policy(SET CMP0054 OLD)
endif()
# installation dir of oocmake
set(oocmake_base_dir "${CMAKE_CURRENT_LIST_DIR}")

# include functions needed for initializing oocmake
include(CMakeParseArguments)


# get temp dir which is needed by a couple of functions in oocmake
set(oocmake_tmp_dir "$ENV{TMP}")
if(NOT oocmake_tmp_dir)
	set(oocmake_tmp_dir "${CMAKE_CURRENT_LIST_DIR}/tmp")
endif()
file(TO_CMAKE_PATH "${oocmake_tmp_dir}" oocmake_tmp_dir)


# dummy function which is overwritten and in this form just returns the temp_dir
function(oocmake_config key)
	return("${oocmake_tmp_dir}")
endfunction()

## create invoke later functions 
function(task_enqueue callable)
  ## semicolon encode before string_semicolon_encode exists
  string(ASCII  31 us)
  string(REPLACE ";" "${us}" callable "${callable}")
  set_property(GLOBAL APPEND PROPERTY __initial_invoke_later_list "${callable}") 
  return()
endfunction()



## includes all cmake files of oocmake 
include("${oocmake_base_dir}/cmake/core/require.cmake")

require("${oocmake_base_dir}/cmake/*.cmake")


## setup global variables to contain command_line_args
parse_command_line(command_line_args "${command_line_args}") # parses quoted command line args
map_set(global "command_line_args" ${command_line_args})
map_set(global "unused_command_line_args" ${command_line_args})

## todo... change this 
# setup oocmake config
map()
	kv(base_dir
		LABELS --oocmake-base-dir
		MIN 1 MAX 1
		DISPLAY_NAME "oo-cmake installation dir"
		DEFAULT "${CMAKE_CURRENT_LIST_DIR}"
		)
  kv(keep_temp 
    LABELS --keep-tmp --keep-temp -kt 
    MIN 0 MAX 0 
    DESCRIPTION "does not delete temporary files after") 
  kv(temp_dir
  	LABELS --temp-dir
  	MIN 1 MAX 1
  	DESCRIPTION "the directory used for temporary files"
  	DEFAULT "${oocmake_tmp_dir}/cutil/temp"
  	)
  kv(cache_dir
  	LABELS --cache-dir
  	MIN 1 MAX 1
  	DESCRIPTION "the directory used for caching data"
  	DEFAULT "${oocmake_tmp_dir}/cutil/cache"
  	)
  kv(bin_dir
    LABELS --bin-dir
    MIN 1 MAX 1
    DEFAULT "${CMAKE_CURRENT_LIST_DIR}/bin"
    )

end()
ans(oocmake_config_definition)

cd("${CMAKE_SOURCE_DIR}")
# setup config_function for oocmake
config_setup("oocmake_config" ${oocmake_config_definition})


## run all currently enqueued tasks
task_run_all()

## check if in script mode and script file is equal to this file
## then invoke either cli mode
cmake_entry_point()
ans(entry_point)
if("${CMAKE_CURRENT_LIST_FILE}" STREQUAL "${entry_point}")
  cmakepp_cli()
endif()



## variables expected by cmake's find_package method
set(CMAKEPP_FOUND true)

set(CMAKEPP_VERSION_MAJOR "0")
set(CMAKEPP_VERSION_MINOR "0")
set(CMAKEPP_VERSION_PATCH "0")
set(CMAKEPP_VERSION "${CMAKEPP_VERSION_MAJOR}.${CMAKEPP_VERSION_MINOR}.${CMAKEPP_VERSION_PATCH}")
set(CMAKEPP_BASE_DIR "${oocmake_base_dir}")
set(CMAKEPP_BIN_DIR "${oocmake_base_dir}/bin")
set(CMAKEPP_TMP_DIR "${oocmake_tmp_dir}")