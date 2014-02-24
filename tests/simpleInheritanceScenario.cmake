function(simpleInheritanceScenario)
	obj_create(animal)
	obj_create(mamal)
	obj_create(dog)
	obj_create(cat)
	obj_create(bird)

	obj_setfunction(
		${animal} 
		"function(eat result)\n  obj_get(\${this} food food) \n  \n return_value(\"I eat \${food}\") \n endfunction() "
	)

	obj_setprototype(${bird} ${animal})
	obj_setprototype(${mamal} ${animal})
	obj_setprototype(${dog} ${mamal})
	obj_setprototype(${cat} ${mamal})

	obj_set(${dog} food Dogfood)
	obj_set(${cat} food Catfood)
	obj_set(${bird} food Birdfood)



	obj_callmember(${bird} eat res1)
	obj_callmember(${dog} eat res2)
	obj_callmember(${cat} eat res3)


	assert("I eat Birdfood" STREQUAL ${res1})
	assert("I eat Dogfood" STREQUAL ${res2})
	assert("I eat Catfood" STREQUAL ${res3})


endfunction()