function(test)

	ref_gettype("ref:global:type:123asd123" res)
	assert(${res} STREQUAL type)
	ref_gettype("ref:global:map:123asd123" res)
	assert(${res} STREQUAL map)

	map_create(map)
	ref_gettype(${map} res)
	assert(${res} STREQUAL map)

	ref_new(ref)
	ref_gettype(${ref} res)
	assert(${res} STREQUAL none)
	

	# serialize empty value
	json_serialize(res "")
	assert(NOT res)

	# serialze simple value
	json_serialize(res "hello!")
	assert(res)
	assert("\"hello!\"" STREQUAL ${res})

	#empty object
	element(uut MAP)
	element(END)
	json_serialize(res ${uut})
	assert("{}" STREQUAL ${res})

	# empty list
	element(uut LIST)
	element(END)
	json_serialize(res ${uut})
	assert("[]" STREQUAL ${res})

	# ref
	ref_new(uut)
	ref_set(${uut} "a b c")
	json_serialize(res ${uut})
	assert("\"a b c\"" STREQUAL ${res})

	# list with one element
	element(uut LIST)
	value(1)
	element(END)
	json_serialize(res ${uut})
	assert("[\"1\"]" STREQUAL ${res})

	# list with multiple elements element
	element(uut LIST)
	value(1)
	value(2)
	element(END)
	json_serialize(res ${uut})
	assert("[\"1\",\"2\"]" STREQUAL ${res})

	# object with single value
	element(uut MAP)
	value(KEY k1 val1)
	element(END)
	json_serialize(res ${uut})
	assert("{\"k1\":\"val1\"}" STREQUAL ${res})

	# object with multiple value
	element(uut MAP)
	value(KEY k1 val1)
	value(KEY k2 val2)
	element(END)
	json_serialize(res ${uut})
	assert("{\"k1\":\"val1\",\"k2\":\"val2\"}" STREQUAL ${res})

	# list with single map
	element(uut LIST)
	element()
	value(KEY k1 1)
	element(END)
	element(END)
	json_serialize(res ${uut})
	assert("[{\"k1\":\"1\"}]" STREQUAL ${res})


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
	json_serialize(res ${uut})
	assert("[{\"k1\":\"1\",\"k2\":\"2\",\"k3\":\"3\"},[\"1\",\"2\"],\"a\",\"b\"]" STREQUAL ${res})


	# test for indentations
		element(uut LIST)
		element(MAP)
			value(KEY k1 1)
			value(KEY k2 2)
			value(KEY k3 3)
			element(k4 MAP)				
				value(KEY k1 1)
				value(KEY k2 2)
				value(KEY k3 3)
			element(END)
		element(END)
		element(LIST)
			value(1)
			value(2)
		element(END)
		value(a)
		value(b)
	element(END)
	json_serialize(res ${uut} INDENTED)



	json_tokenize(tokens "")
	assert(NOT tokens)

	json_tokenize(tokens "{}")
	assert(EQUALS ${tokens} "{" "}")

	json_tokenize(tokens "[]")
	assert(EQUALS ${tokens} "<" ">")

	json_tokenize(tokens "\"some string\"")
	assert(EQUALS ${tokens} "\"some string\"")

	json_tokenize(tokens "[\"1\"]")
	assert(EQUALS ${tokens} "<" "\"1\"" ">")

	json_tokenize(tokens "[\"1\",\"2\"]")
	assert(EQUALS ${tokens} "<" "\"1\"" "," "\"2\"" ">")

	json_tokenize(tokens "{\"key\":\"val\"}")
	assert(EQUALS ${tokens} "{" "\"key\"" ":" "\"val\"" "}")

	json_deserialize(res "")
	assert(NOT res)

	json_deserialize(res "{}")
	assert(res)
	ref_isvalid(is_ref ${res} )
	assert(is_ref MESSAGE "expected res to be a ref")

	json_deserialize(res "[]")
	assert(res)
	ref_isvalid(is_ref ${res})
	assert(is_ref MESSAGE "expected res to be a ref")

	json_deserialize(res "\"teststring\"")
	assert(${res} STREQUAL "teststring")

	json_deserialize(res "[\"1\"]")
	map_navigate(${res} val "[0]")
	assert(${val} STREQUAL "1")

	json_deserialize(res "[\"1\", \"2\"]")
	map_navigate(${res} val "[0]")
	assert(${val} STREQUAL "1")
	map_navigate(${res} val "[1]")
	assert(${val} STREQUAL "2")

	json_deserialize(res "{ \"key\" : \"value\"}")
	map_navigate(${res} val "key")
	assert(${val} STREQUAL "value")


	json_deserialize(res "{ \"key\" : \"value\", \"key2\" : \"val2\"}")
	map_navigate(${res} val "key")
	assert(${val} STREQUAL "value")
	map_navigate(${res} val "key2")
	assert(${val} STREQUAL "val2")



	json_deserialize(res "{ \"key\" : {\"key3\":\"myvalue\" }, \"key2\" : \"val2\"}")
	map_navigate(${res} val "key2")
	assert(${val} STREQUAL "val2")
	map_navigate(${res} val "key.key3")
	assert(${val} STREQUAL "myvalue")



	json_deserialize(res "{ \"key\" : [\"1\", \"2\"], \"key2\" : \"val2\"}")
	map_navigate(${res} val "key2")
	assert(${val} STREQUAL "val2")
	map_navigate(${res} val "key[0]")
	assert(${val} STREQUAL "1")
	map_navigate(${res} val "key[1]")
	assert(${val} STREQUAL "2")



	json_deserialize(res "{ \"key\" : [{\"k1\":\"v1\"}, \"2\"], \"key2\" : \"val2\"}")
	map_navigate(${res} val "key[0].k1")
	assert(${val} STREQUAL "v1")




		

endfunction()
