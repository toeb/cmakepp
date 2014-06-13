# orders a list by a comparator function
function(list_order __list_order_lst comparator)
	
	lambda(comparator "${comparator}")
	#message("${comparator}")
	function_import("${comparator}" as comparator_function)


	
	list(LENGTH ${__list_order_lst} len)

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
		list(GET ${__list_order_lst} ${i} a)
		list(GET ${__list_order_lst} ${j} b)
		comparator_function(res ${a} ${b})
		if(res LESS 0)
			list_swap(${__list_order_lst} ${i} ${j})
		endif()


		math(EXPR i "${i} + 1")
	endwhile()
	
	set(${__list_order_lst} ${${__list_order_lst}} PARENT_SCOPE)
endfunction()