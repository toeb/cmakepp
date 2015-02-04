message(STATUS "running test for cmake functions")

# include oo-cmake
include("${CMAKE_CURRENT_LIST_DIR}/../cmakepp.cmake")

#message("configuratiation")
#print_locals()

# glob tets
file(GLOB_RECURSE tests  "${CMAKE_CURRENT_LIST_DIR}/../tests/**.cmake")
set(package_dir "${CMAKE_CURRENT_LIST_DIR}")


oocmake_config(temp_dir)
ans(temp_dir)
set(test_dir "${temp_dir}/test_dir")


#set(OOCMAKE_DEBUG_EXECUTE true)

foreach(test ${tests})
  get_filename_component(test "${test}" REALPATH)
  
  file(REMOVE_RECURSE "${test_dir}")
  file(MAKE_DIRECTORY "${test_dir}")
  #function_import("${test}" as test_function REDEFINE)
  message(STATUS "running test ${test}... ")

  cd("${test_dir}")


  call("${test}"())
  #test_function()
  message(STATUS "success!")
endforeach()