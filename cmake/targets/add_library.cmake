
macro(add_library)
  _add_library(${ARGN})
  event_emit(add_library ${ARGN})

  event_emit(on_target_added library ${ARGN})
  target_register(${ARGN})


  
endmacro()