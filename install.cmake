## todo
message("Installing CMake++")

# download a cmakepp release
set(cmakepp_uri "https://github.com/toeb/cmakepp/releases/download/v0.0.3/cmakepp-0.0.3.cmake")
set(target_file "${CMAKE_CURRENT_BINARY_DIR}/__cmakepp.cmake")
file(DOWNLOAD "${cmakepp_uri}" "${target_file}" STATUS status)
if(NOT "${status}" MATCHES "0;")
  message(FATAL_ERROR "failed to download cmakepp")
endif()  

include("${target_file}")
file(REMOVE "${target_file}")


ls()
ans(res)
json_print(${res})

# download newest cmakepp release

# delete temporary files

# update system path / install to cmake directory

# create aliases for cmake scripts
# alias_create("icmake" "cmake -P ${cutil_base_dir}/dependencies/oocmake/icmake.cmake")
# alias_create("cmakepp" "cmake -P ${cutil_base_dir}/dependencies/oocmake/cmakepp.cmake")




# message(STATUS "checking cutil installation")
# if(((EXISTS cutil) AND (EXISTS $ENV{CUTIL_DIR})))
#   message(STATUS "cutil is already installed")
# endif()
# message(STATUS installing cutil)

# find_package(Git)
# if(NOT GIT_FOUND)
#   message(FATAL_ERROR "cutil installation aborted: install git")
# endif()

# set(cutil_current_dir "${CMAKE_CURRENT_LIST_DIR}")
# set(cutil_base_dir "${CMAKE_CURRENT_LIST_DIR}/cutil")
# set(tmp_dir "${cutil_current_dir}/tmp")

# if(EXISTS ${cutil_base_dir})
#   message(STATUS "cutil is already installed")
#   return()
# endif()

# execute_process(COMMAND "${GIT_EXECUTABLE}" clone "https://github.com/toeb/cutil.git" "${cutil_base_dir}")
# execute_process(COMMAND "${GIT_EXECUTABLE}" submodule init WORKING_DIRECTORY "${cutil_base_dir}")
# execute_process(COMMAND "${GIT_EXECUTABLE}" submodule update --recursive WORKING_DIRECTORY "${cutil_base_dir}")


# include("${cutil_base_dir}/cmake/cutil_run.cmake")
# cutil_run("${cutil_base_dir}")

# path("${cutil_base_dir}")
# ans(cutil_base_dir)


# shell_env_set(CUTIL_PATH "${cutil_base_dir}")

# oocmake_config(bin_dir)
# ans(bin_dir)

# alias_create("cutil" "cmake -P ${cutil_base_dir}/cmake/cutil.cmake")
# alias_create("cps" "cutil cps")
# alias_create("icmake" "cmake -P ${cutil_base_dir}/dependencies/oocmake/icmake.cmake")
# alias_create("cmakepp" "cmake -P ${cutil_base_dir}/dependencies/oocmake/cmakepp.cmake")
# alias_create("cts" "cutil -t ${cutil_base_dir}/dependencies/cts cts")
# alias_create("cgen" "cutil -t ${cutil_base_dir}/dependencies/cgen cgen")

message(STATUS "Install Complete - re-login for changes to take effect")