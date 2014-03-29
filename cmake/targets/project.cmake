

macro(project name)
  _project(${name} ${ARGN})
  message(DEBUG LEVEL 4 "registering project '${name}'")
endmacro()