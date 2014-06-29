function(test)

 	set(lstA 0 1)
 	set(lstB 0 1)
 	set(lstC 0 1)
 	ref_new()
  ans(myref)
 	function(test_list_foreach)
 		ref_append(${myref} ${a} ${b} ${c})
 	endfunction()
 	list_foreach(test_list_foreach "a in lstA, b in lstB, c in lstC" )
 	ref_get(${myref} )
  ans(values)
 	assert(EQUALS ${values} 0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 1 1)


 	set(lstA)
 	ref_set(${myref} "")
 	list_foreach(test_list_foreach "a in lstA, b in lstB, c in lstC" )
 	ref_get(${myref} )
  ans(values)
  	assert(NOT values)

endfunction()