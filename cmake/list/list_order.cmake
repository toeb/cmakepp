
# orders a list by a comparator function
function(list_order result lst comparator)
	
	lambda(comparator "${comparator}")
	message("${comparator}")
	import_function("${comparator}" as comparator_function)


	
	list(LENGTH lst len)

	set(i 0)
	set(j 0)
	while(true)

		if(NOT ${i} LESS ${len})
			set(i 0)
			math(EXPR j "${j} + 1")
		endif()

		if(NOT ${j} LESS ${len}  )
			break()
		endif()
		list(GET lst ${i} a)
		list(GET lst ${j} b)
		comparator_function(res ${a} ${b})
		if(res LESS 0)
			list_swap(lst ${i} ${j})
		endif()


		math(EXPR i "${i} + 1")
	endwhile()
	
	set(${result} ${lst} PARENT_SCOPE)
endfunction()