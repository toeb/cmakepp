function(list_unique __list_unique_lst)
	list(REMOVE_DUPLICATES ${__list_unique_lst})
	set(${__list_unique_lst} ${${__list_unique_lst}} PARENT_SCOPE)
endfunction()