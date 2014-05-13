

macro(project name)
  _project(${name} ${ARGN})
  message(DEBUG LEVEL 4 "registering project '${name}'")
  map_new()
  ans(cmake_current_project)
  map_set(${cmake_current_project} name "${name}")
  map_set(${cmake_current_project} directory "${CMAKE_CURRENT_LIST_DIR}")
endmacro()