message(STATUS "running test for cmake functions")

# include cmakepp
include("${CMAKE_CURRENT_LIST_DIR}/../cmakepp.cmake")


## execute all tests in test directory
if("$ENV{CMAKEPP_TEST_EXECUTE_PARALLEL}_" STREQUAL "true_" )
  ## removed package source tests as they fail non deterministically
  test_execute_glob_parallel(
    "${CMAKE_CURRENT_LIST_DIR}/../tests/**.cmake" 
    "!${CMAKE_CURRENT_LIST_DIR}/../tests/package/package_source_tests/**.cmake" 
    --recurse --no-status)
else()
  test_execute_glob(
    "${CMAKE_CURRENT_LIST_DIR}/../tests/**.cmake" 
    "!${CMAKE_CURRENT_LIST_DIR}/../tests/package/package_source_tests/**.cmake" 
    --recurse)
endif()

## beep three times to indicate end of testrun...
#beep()
#beep()
#beep()