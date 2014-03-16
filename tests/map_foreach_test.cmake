function(test)

 	set(lstA 0 1)
 	set(lstB 0 1)
 	set(lstC 0 1)
 	ref_new(myref)
 	function(test_map_foreach)
 		ref_append(${myref} ${a} ${b} ${c})
 	endfunction()
 	map_foreach(test_map_foreach "a in lstA, b in lstB, c in lstC" )
 	ref_get(${myref} values)
 	assert(EQUALS ${values} 0 0 0 1 0 0 0 1 0 1 1 0 0 0 1 1 0 1 0 1 1 1 1 1)


 	set(lstA)
 	ref_set(${myref} "")
 	map_foreach(test_map_foreach "a in lstA, b in lstB, c in lstC" )
 	ref_get(${myref} values)
  	assert(NOT values)

endfunction()