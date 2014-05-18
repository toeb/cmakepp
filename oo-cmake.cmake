cmake_minimum_required(VERSION 2.8.7)

cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)
# needed in some functions
include(CMakeParseArguments)

# setup some functions temporarily for pre run (these are just simplified versions of their originals and are soon replace)
function(require file)
	file(GLOB_RECURSE res "${file}")
	if(NOT res)
		message(FATAL_ERROR "could not find required file for '${file}'")
	endif()
	foreach(file ${res})
		include("${file}")
	endforeach()
endfunction()

set(oocmake_tmp_dir "$ENV{TMP}")
if(NOT oocmake_tmp_dir)

	set(oocmake_tmp_dir "${CUTIL_CURRENT_BINARY_DIR}")
endif()
file(TO_CMAKE_PATH "${oocmake_tmp_dir}" oocmake_tmp_dir)

function(oocmake_config key)
	return("${oocmake_tmp_dir}")
endfunction()



## includes all cmake files of oocmake 
require("${CMAKE_CURRENT_LIST_DIR}/cmake/*.cmake")

## setup global variables
map_set(global "command_line_args" ${ARGN})
map_set(global "unused_command_line_args" ${ARGN})

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
    kv(log_level 
      LABELS --log-level -ll 
      MIN 1 MAX 1 
      DESCRIPTION "sets the loglevel for messages" 
      DEFAULT 3)
    kv(debug_mode 
      LABELS --debug -dbg -d 
      MIN 0 MAX 0 
      DESCRIPTION "enables debug mode")
    kv(quiet_mode 
      LABELS --quiet -q 
      MIN 0 MAX 0 
      DESCRIPTION "No output occurs")
end()
ans(oocmake_config_definition)

# setup config_function for oocmake
config_setup("oocmake_config" ${oocmake_config_definition})

