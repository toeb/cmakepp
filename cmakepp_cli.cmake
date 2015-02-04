## this cmake script executes the lazy cmake code from the commandline 
## and returns the result in json or qm dependeing on the format flag (--json, --qm)
## 
## 
include("${CMAKE_CURRENT_LIST_DIR}/cmakepp.cmake")
cd("${CMAKE_CURRENT_BINARY_DIR}")
cmakepp_cli()