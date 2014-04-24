function(test)
	obj_create(obj)
	obj_setfunction(${obj} "function(myfu)\nmessage(\"\${arg} \${this} \${ARGN}\")\nendfunction()")


	obj_get(${obj}  myfu)
  ans(fu)
	assert(fu)
	assert("${fu}" STREQUAL "function(myfu)\nmessage(\"\${arg} \${this} \${ARGN}\")\nendfunction()")
endfunction()