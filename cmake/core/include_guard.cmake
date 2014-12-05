
#include guard returns if the file was already included 
# usage :  at top of file write include_guard(${CMAKE_CURRENT_LIST_FILE})
macro(include_guard __include_guard_file)
  #string(MAKE_C_IDENTIFIER "${__include_guard_file}" __include_guard_file)
  get_property(is_included GLOBAL PROPERTY "ig_${__include_guard_file}")
  if(is_included)
    _return()
  endif()
  set_property(GLOBAL PROPERTY "ig_${__include_guard_file}" true)
endmacro()