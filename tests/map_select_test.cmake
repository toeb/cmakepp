function(test)

element(MAP)

	value(KEY k1 v1)
	value(KEY k2 v2)
	value(KEY k3 v3)
	element(k4 LIST)
		value(1)
		value(2)
		value(3)
	element(END)
	element(k5 MAP)
		value(KEY k1 va)
		value(KEY k2 vb)
		value(KEY k3 vc)
	element(END)
element(END uut)



map_select(res "new { \"a\" : \"{uut.k3}\", \"b\" :  { \"a\" : \"{uut.k5.k1}\"}, \"c\": \"{uut.k5.k2}\"}")

map_format(res "{${res}.a}-{${res}.b.a}-{${res}.c}")

assert("${res}" STREQUAL "v3-va-vb")

endfunction()