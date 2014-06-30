function(register_project name)


  message(DEBUG LEVEL 4 "registering project '${name}'")
  map_new()
  ans(cmake_current_project)
  map_set(${cmake_current_project} name "${name}")
  map_set(${cmake_current_project} directory "${CMAKE_CURRENT_LIST_DIR}")

endfunction()



macro(project)
  set(parent_project_name "${PROJECT_NAME}")
  _project(${ARGN})
  set(project_name "${PROJECT_NAME}") 
  event_emit("project" ${ARGN})
endmacro()

