function(test)

obj("{
	k1:'v1',
	k2:'v2',
	k3:'v3',
	k4:[1,2,3],
	k5:{
		k1:'va',
		k2:'vb',
		k3:'vc'
	}
}")
ans(uut)




map_transform( "new { \"a\" : \"{uut.k3}\", \"b\" :  { \"a\" : \"{uut.k5.k1}\"}, \"c\": \"{uut.k5.k2}\"}")
ans(res)
map_format( "{${res}.a}-{${res}.b.a}-{${res}.c}")
ans(res)
assert("${res}" STREQUAL "v3-va-vb")

endfunction()