
function(obj_export_member this member_name)
	obj_set(${this} ${member_name} ${${member_name}})
endfunction()