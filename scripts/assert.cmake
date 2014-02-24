
function(assert)
	if(NOT (${ARGN}))
		message(FATAL_ERROR "assertion failed: ${ARGN}")
	endif()
endfunction()