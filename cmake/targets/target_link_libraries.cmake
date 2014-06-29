
macro(target_link_libraries)
  _target_link_libraries(${ARGN})
  event_emit(target_link_libraries ${ARGN})
  
endmacro()