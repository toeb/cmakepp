cmake_minimum_required(VERSION 2.8.7)
## some globals...
set(github_api_token "?client_id=$ENV{GITHUB_DEVEL_TOKEN_ID}&client_secret=$ENV{GITHUB_DEVEL_TOKEN_SECRET}")


# this initialization script excpects configuration arguments in the var 
# command_line_args.  when including it be sure to specifiy them as needed
# like so: 
# set(command_line_args "--quiet-mode --cache-dir \"path to cache dir\"") # etc
# then
# include(/path/to/oo-cmake.cmake)

get_property(is_included GLOBAL PROPERTY oocmake_include_guard)
if(is_included)
  _return()
endif()
set_property(GLOBAL PROPERTY oocmake_include_guard true)

#include("${CMAKE_CURRENT_LIST_DIR}/cmake/core/include_guard.cmake")
#include_guard(${CMAKE_CURRENT_LIST_FILE})



cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)

# installation dir of oocmake
set(oocmake_base_dir "${CMAKE_CURRENT_LIST_DIR}")

# include functions needed for initializing oocmake
include(CMakeParseArguments)
#include("${oocmake_base_dir}/cmake/core/parse_command_line.cmake")


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

## includes all cmake files of oocmake 

include("${oocmake_base_dir}/cmake/core/require.cmake")

require("${oocmake_base_dir}/cmake/*.cmake")


## setup global variables to contain command_line_args
parse_command_line(command_line_args "${command_line_args}") # parses quoted command line args
map_set(global "command_line_args" ${command_line_args})
map_set(global "unused_command_line_args" ${command_line_args})
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
  kv(show_help
    LABELS --oocmake-show-help
    MIN 0 MAX 0
    DESCRIPTION "Show Help for oocmake config options"
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
oocmake_config(show_help)
ans(show_help)
if(show_help)
  oocmake_config(help)
endif()


