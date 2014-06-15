# orders a list by a comparator function
function(list_order __list_order_lst comparator)
	list(LENGTH ${__list_order_lst} len)

	# copyright 2014 Tobias Becker -> triple s "slow slow sort"
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
		rcall(res = "${comparator}"("${a}" "${b}"))
		if(res LESS 0)
			list_swap(${__list_order_lst} ${i} ${j})
		endif()


		math(EXPR i "${i} + 1")
	endwhile()
	return_ref(${__list_order_lst})
endfunction()