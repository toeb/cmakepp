project(cmakeJsonParser)

file(GLOB sources "${CMAKE_CURRENT_LIST_DIR}/*.h" "${CMAKE_CURRENT_LIST_DIR}/*.cpp")

add_executable(cmakeJsonParser ${sources})

