function(test)
	message("test inconclusive")
	return()

	script("[
		{
			k1:'v11',
			k2:'v12'
		},
		{
			k1:'v21',
			k2:'v22'
		},
		{
			k1:'v31',
			k2:'v32'
		}
	]")
	ans(lst)
	# element(LIST)
	# 	element(MAP)
	# 		value(KEY k1 v11)
	# 		value(KEY k2 v12)
	# 	element(END)
	# 	element(MAP)
	# 		value(KEY k1 v21)
	# 		value(KEY k2 v22)
	# 	element(END)
	# 	element(MAP)
	# 		value(KEY k1 v31)
	# 		value(KEY k2 v32)
	# 	element(END)
	# element(END lst)

	#ref_get(${lst} )
	#ans(lst)
	map_select( "from a in lst select {a.k1}{a.k2}")
	ans(res)
	assert(EQUALS ${res} v11v12 v21v22 v31v32)
	
endfunction()