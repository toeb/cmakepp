
function(obj_import_member this member_name)
	obj_get(${this} value ${member_name})
	set(${member_name} ${value} PARENT_SCOPE)
endfunction()