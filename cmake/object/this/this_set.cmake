# sets both the objects proerpty and the local cmake variable called ${member_name}
function(this_set member_name)
	obj_set("${this}" "${member_name}" "${ARGN}")
	set(${member_name} "${ARGN}" PARENT_SCOPE)
endfunction()




function(this_append member_name)
  obj_get("${this}" "${member_name}")
  ans(value)
  obj_set("${this}" "${member_name}" ${value} "${ARGN}")
endfunction()