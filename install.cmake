## todo
message("installing cmakepp")
# download a cmakepp release

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