message(STATUS "running test for cmake functions")

# include cmakepp
include("${CMAKE_CURRENT_LIST_DIR}/../cmakepp.cmake")


## execute all tests in test directory
test_execute_glob("${CMAKE_CURRENT_LIST_DIR}/../tests/**.cmake" --recurse)