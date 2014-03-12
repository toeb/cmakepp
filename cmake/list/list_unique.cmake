function(list_unique result lst)
	list(REMOVE_DUPLICATES lst)
	set(${result} ${lst} PARENT_SCOPE)
endfunction()