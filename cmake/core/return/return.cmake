macro(return)
  set(__ans "${ARGN}" PARENT_SCOPE)
	_return()
endmacro()