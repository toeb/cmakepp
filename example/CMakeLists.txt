cmake_minimum_required(VERSION 2.8)
include("../oo-cmake.cmake")


message("creating a simple inheritance example")

obj_create(animal)
	obj_create(mamal)
	obj_create(dog)
	obj_create(cat)
	obj_create(bird)

	obj_set(
		${animal} 
		"eat" 
		RAW 
		"function(eat this result)\n  obj_get(\${this} food food) \n message(\"I am eating \${food}\")\n return_value(\"I eat \${food}\") \n endfunction() "
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


	assert_stringequal("should return correct food" "I eat Birdfood" ${res1})
	assert_stringequal("should return correct food" "I eat Dogfood" ${res2})
	assert_stringequal("should return correct food" "I eat Catfood" ${res3})