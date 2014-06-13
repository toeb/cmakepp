# swaps the element of lst at i with element at index j
macro(list_swap lst i j)
	list(GET ${lst} ${i} a)
	list(GET ${lst} ${j} b)
	list_replace_at(${lst} ${i} ${b})
	list_replace_at(${lst} ${j} ${a})
endmacro()

