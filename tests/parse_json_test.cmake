function(test)
	return()
	# round trip serialize special symbols
	
	element(MAP)
		value(KEY k1 a b c)

	element(END original)

	json_serialize( "${original}")	
	ans(json)
	json_deserialize( "${json}")
	ans(copy)

	map_equal( ${original} ${copy})
	ans(res)
	assert(res)
	

	# test for indentations
	element(uut LIST)
		element(MAP)
			value(KEY k1 1)
			value(KEY k2 2)
			value(KEY k3 3)
			element(k4 MAP)				
				value(KEY k1 1)
				value(KEY k2 2)
				value(KEY k3 3 4 5)
			element(END)
		element(END)
		element(LIST)
			value(1)
			value(2)
		element(END)
		value(a)
		value(b)
	element(END)
	json_serialize( ${uut} INDENTED)
	ans(res)

# check escape characters
	json_serialize( "\"\"\\\n\r\t")
	ans(res)
	assert("${res}" STREQUAL "\"\\\"\\\"\\\\\\n\\r\\t\"")

# cehck list handling
	set(lst a b c)
	json_serialize( "${lst}")
	ans(res)
	json_deserialize( "${res}")
	ans(res)
	assert(EQUALS ${lst} a b c)


	#return()

	ref_isvalid("a;b;c;d" )
	ans(isref)
	assert(NOT isref)

	# map with cmake list value
	element(uut MAP)
	value(KEY k1 a b c d)
	element(END)
	json_serialize( ${uut})
	ans(res)
	

	json_deserialize( "\"a;b;c\"")
	ans(res)
	assert(EQUALS "a;b;c" ${res} )
	

	map_new()
    ans(map)
	ref_gettype(${map})
	ans(res)
	assert(${res} STREQUAL map)


	


	# list with differnt elements map
	element(uut LIST)
		element(MAP)
			value(KEY k1 1)
			value(KEY k2 2)
			value(KEY k3 3)
		element(END)
		element(LIST)
			value(1)
			value(2)
		element(END)
		value(a)
		value(b)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("[{\"k1\":\"1\",\"k2\":\"2\",\"k3\":\"3\"},[\"1\",\"2\"],\"a\",\"b\"]" STREQUAL ${res})





	json_tokenize(tokens "")
	assert(NOT tokens)

	json_tokenize(tokens "{}")
	assert(EQUALS ${tokens} "{" "}")

	json_tokenize(tokens "[]")
	#assert(EQUALS ${tokens} "†" "‡")

	json_tokenize(tokens "\"some string\"")
	assert(EQUALS ${tokens} "\"some string\"")

	json_tokenize(tokens "\"abc;def\"")
	assert(EQUALS ${tokens} "\"abc;def\"")

	json_tokenize(tokens "[\"1\"]")
#	assert(EQUALS ${tokens} "†" "\"1\"" "‡")

	json_tokenize(tokens "[\"1\",\"2\"]")
	#assert(EQUALS ${tokens} "†" "\"1\"" "," "\"2\"" "‡")

	json_tokenize(tokens "{\"key\":\"val\"}")
	assert(EQUALS ${tokens} "{" "\"key\"" ":" "\"val\"" "}")

	# serialize empty value
	json_serialize( "")
	ans(res)
	assert(NOT res)


	# serialze simple value
	json_serialize( "hello!")
	ans(res)
	assert(res)
	assert("\"hello!\"" STREQUAL ${res})

	# serialize a cmake list value
	json_serialize( "a;b;c")
	ans(res)
	assert(res)
	assert(EQUALS "\"a\\\\;b\\\\;c\"" ${res})

	#empty object
	element(uut MAP)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("{}" STREQUAL ${res})


	# empty list
	element(uut LIST)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("[]" STREQUAL ${res})

	# ref
	ref_new(uut)
	ref_set(${uut} "a b c")
	json_serialize( ${uut})
	ans(res)
	assert("\"a b c\"" STREQUAL ${res})

	# list with one element
	element(uut LIST)
	value(1)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("[\"1\"]" STREQUAL ${res})

	# list with multiple elements element
	element(uut LIST)
	value(1)
	value(2)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("[\"1\",\"2\"]" STREQUAL ${res})

	# object with single value
	element(uut MAP)
	value(KEY k1 val1)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("{\"k1\":\"val1\"}" STREQUAL ${res})

	# object with multiple value
	element(uut MAP)
	value(KEY k1 val1)
	value(KEY k2 val2)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("{\"k1\":\"val1\",\"k2\":\"val2\"}" STREQUAL ${res})


	# list with single map
	element(uut LIST)
	element()
	value(KEY k1 1)
	element(END)
	element(END)
	json_serialize( ${uut})
	ans(res)
	assert("[{\"k1\":\"1\"}]" STREQUAL ${res})


	# deserialize a empty value
	json_deserialize( "")
	ans(res)
	assert(NOT res)


	# deserialize a empty object
	json_deserialize( "{}")
ans(res)
		assert(res)
	ref_isvalid( ${res}  )
	ans(is_ref)
	assert(is_ref MESSAGE "expected res to be a ref")

	# desirialize a empty array
	json_deserialize( "[]")
	ans(res)
	assert(res)
	ref_isvalid( ${res} )
	ans(is_ref)
	assert(is_ref MESSAGE "expected res to be a ref")


	# deserialize a simple value
	json_deserialize( "\"teststring\"")
	ans(res)
	assert(${res} STREQUAL "teststring")

if(false)
# these tests currently do not work because of utf8 issue
	# deserialize a array with one value
	json_deserialize( "[\"1\"]")
	ans(res)
	map_navigate(val "res[0]")
	assert(${val} STREQUAL "1")


	#deserialize a array with multiple values
	json_deserialize( "[\"1\", \"2\"]")
	ans(res)
	map_navigate(val "res[0]")
	assert(${val} STREQUAL "1")
	map_navigate(val "res[1]")
	assert(${val} STREQUAL "2")
endif()
	# deserialize a simple object with one value
	json_deserialize( "{ \"key\" : \"value\"}")
	ans(res)
	map_navigate(val "res.key")
	assert(${val} STREQUAL "value")

	# deserialize a simple object with multiple values
	json_deserialize( "{ \"key\" : \"value\", \"key2\" : \"val2\"}")
	ans(res)
	map_navigate(val "res.key")
	assert(${val} STREQUAL "value")
	map_navigate(val "res.key2")
	assert(${val} STREQUAL "val2")


	# deserialize a simple nested structure
	json_deserialize( "{ \"key\" : {\"key3\":\"myvalue\" }, \"key2\" : \"val2\"}")
	ans(res)
	map_navigate(val "res.key2")
	assert(${val} STREQUAL "val2")
	map_navigate(val "res.key.key3")
	assert(${val} STREQUAL "myvalue")

	# deserialize a nested structure containing both arrays and objects
	json_deserialize( "{ \"key\" : [\"1\", \"2\"], \"key2\" : \"val2\"}")
	ans(res)
	map_navigate(val "res.key2")
	assert(${val} STREQUAL "val2")
	map_navigate(val "res.key[0]")
	assert(${val} STREQUAL "1")
	map_navigate(val "res.key[1]")
	assert(${val} STREQUAL "2")

	# deserialize a 'deeply' nested structure and get a value
	json_deserialize( "{ \"key\" : [{\"k1\":\"v1\"}, \"2\"], \"key2\" : \"val2\"}")
	ans(res)
	map_navigate(val "res.key[0].k1")
	assert(${val} STREQUAL "v1")


endfunction()
