function(test)


	obj_new(config Configuration)

	obj_callmember(${config} AddConfigurationFile global "${test_dir}/conf1.json")
	obj_callmember(${config} AddConfigurationFile user "${test_dir}/conf2.json")
	obj_callmember(${config} AddConfigurationFile local "${test_dir}/conf3.json")

	obj_callmember(${config} Set "val1.val2" "1" SCOPE global)
	obj_callmember(${config} Set "val1.val2" "2" SCOPE user)
	obj_callmember(${config} Set "val1.val2" "3" SCOPE local)

	obj_callmember(${config} Set "val1.val3" "3" SCOPE global)
	obj_callmember(${config} Set "val1.val4" "3" SCOPE user)
	obj_callmember(${config} Set "val1.val5" "3" SCOPE local)
	
	obj_callmember(${config} Get res1 "val1.val2")
	obj_callmember(${config} Get res2 "val1.val3")
	obj_callmember(${config} Get res3 "val1.val4")
	obj_callmember(${config} Get res4 "val1.val5")
	set(res5 asd)
	obj_callmember(${config} Get res5 "nonexisting.value")
	obj_callmember(${config} Get res6 "val1.val2" SCOPE global)
	obj_callmember(${config} Get res7 "val1.val2" SCOPE user)
	obj_callmember(${config} Get res8 "val1.val2" SCOPE local)

	assert(${res1} STREQUAL 3)
	assert(${res2} STREQUAL 3)
	assert(${res3} STREQUAL 3)
	assert(${res4} STREQUAL 3)
	assert(NOT res5)
	assert(${res6} STREQUAL 1)
	assert(${res7} STREQUAL 2)
	assert(${res8} STREQUAL 3)


endfunction()