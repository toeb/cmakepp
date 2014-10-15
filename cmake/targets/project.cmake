


# overwrites project so that it can be registered
macro(project)
  set(parent_project_name "${PROJECT_NAME}")
  _project(${ARGN})
  set(project_name "${PROJECT_NAME}") 
  project_register(${ARGN})
  event_emit("project" ${ARGN})
endmacro()

