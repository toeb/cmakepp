# replaces lists  value at i with new_value
function(list_replace_at __list_replace_at_lst i new_value)
	list(INSERT ${__list_replace_at_lst} ${i} ${new_value})	
	math(EXPR i_plusone "${i} + 1" )
	list(REMOVE_AT ${__list_replace_at_lst} ${i_plusone})
  set(${__list_replace_at_lst} ${${__list_replace_at_lst}} PARENT_SCOPE)
endfunction()
