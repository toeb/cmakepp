
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034
macro(eval)
  temp_name(_fname)
  file(WRITE ${_fname} ${ARGN})
  set(cutil_keep_export)
	include(${_fname})
  if(NOT cutil_keep_export)
  	file(REMOVE ${_fname})
  	else()
  	message(STATUS "export kept at ${_fname}")
  endif()
endmacro(eval)