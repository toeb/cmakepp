function(test)	
	obj("{k1:'v1',k2:'v2',k3:'v3'}")
	ans(uut)
	# element(MAP)
	# 	value(KEY k1 v1)
	# 	value(KEY k2 v2)
	# 	value(KEY k3 v3)
	# element(END uut)

	map_edit("uut.k2" --print)

	map_edit("uut.k4" --set hello --print)
	map_edit("uut.k4")

	map_edit(uut.k4 --append ass --print)

	map_edit(uut.k4 --reverse --print)
	map_edit(uut.k4 --remove ass --print)
	map_edit(uut.k5 --print --append "new{ \"hi\":\"h2\"}")

	map_edit(uut.k5 --print --append "new{ \"hi\":\"h3\"}")

	map_edit(uut.k5 --remove)
	map_edit(uut --print)
endfunction()