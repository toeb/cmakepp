## todo

# download a cmakepp release
set(git_uri "https://github.com/toeb/cmakepp")
set(installation_dir "${CMAKE_CURRENT_BINARY_DIR}/cmakepp")
set(cmakepp_uri "${git_uri}/releases/download/v0.0.3/cmakepp-0.0.3.cmake")
set(target_file "${CMAKE_CURRENT_BINARY_DIR}/__cmakepp.cmake")

message(STATUS "Installing CMake++")

file(DOWNLOAD "${cmakepp_uri}" "${target_file}" STATUS status)
if(NOT "${status}" MATCHES "0;")
  message(FATAL_ERROR "failed to download cmakepp")
endif()  

include("${target_file}")
file(REMOVE "${target_file}")

message(STATUS "\n installation_dir: ${installation_dir}")


git(clone "${git_uri}.git" "${installation_dir}")
alias_create("icmake" "cmake -P ${installation_dir}/icmake.cmake")
alias_create("cmakepp" "cmake -P ${installation_dir}/cmakepp_cli.cmake")

shell_env_set(CMAKEPP_PATH "${installation_dir}")

message(STATUS "Install Complete - re-login for changes to take effect")