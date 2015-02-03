# compiles cmake to the specified target directory
# call this script with cmake -P compile.cmake path/to/target/dir
include("${CMAKE_CURRENT_LIST_DIR}/../cmakpp.cmake")


compile_oocmake("${CMAKE_CURRENT_LIST_DIR}" "Findcmakepp.cmake")


