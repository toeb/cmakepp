##Tests can be run with cutil
## cutil test .

macro(tests)

import(oo-cmake)

test_register(shouldCreateAObject)
function(${current_test_name})
 obj_create(res)
 assert("should return a id" res)

endfunction()

test_register(createdObjectShouldExist)
function(${current_test_name})
 obj_create(res)
 obj_exists(${res} val)
 assert("object_exists should have returned true but was ${val}" val)
endfunction()

test_register(shouldGetOwnPropRef)
function(${current_test_name})
	obj_create(res)
	obj_set(${res} val1 "hello world")
	obj_getownref(${res} prop_ref val1)
	assert("should have retuned a propref" prop_ref)
	assert_stringequal("should be correct" "${res}/val1" ${prop_ref})
endfunction()


test_register(shouldGetPropRefValue)
function(${current_test_name})
	obj_create(res)
	obj_set(${res} val1 "hello world")
	obj_getownref(${res} prop_ref val1)
	obj_getrefvalue(${prop_ref} val1)


	assert_stringequal("should have retuned a propref's value" "hello world" ${val1})
endfunction()



test_register(gettypeOfDefaultObject)
function(${current_test_name})
	obj_create(res)
	obj_gettype(${res} type)
	assert("object type should be 'object' instead of ${type}" ${type} STREQUAL "object")
endfunction()


test_register(shouldSetOwnProertyByValue)
function(${current_test_name})
	obj_create(res)
	obj_setownproperty(${res} "val1" "the value")
	assert("property should have been set" EXISTS "${res}/val1")
endfunction()


test_register(hasOwnPropertyShouldReturnTrueForExistingProperty)
function(${current_test_name})
	obj_create(res)
	obj_setownproperty(${res} "val1" "the value")
	obj_hasownproperty(${res} val "val1")
	assert("hasownproperty should have returned true for existing property" val)
endfunction()


test_register(hasOwnPropertyShouldReturnFalseForMissingProperty)
function(${current_test_name})
	obj_create(res)
	obj_setownproperty(${res} "val1" "the value")
	obj_hasownproperty(${res} val "val2")
	assert("hasownproperty should have returned false for missing property" NOT val)
endfunction()


test_register(getownpropertyShouldReturnValueForExistingProperty)
function(${current_test_name})
	obj_create(res)
	obj_setownproperty(${res} "val1" "the value")
	obj_getownproperty(${res} val "val1")

	assert("property should have been set to 'the value'" ${val} STREQUAL "the value")
endfunction()


test_register(getownpropertyShouldReturnNOTFOUNDForMissingProperty)
function(${current_test_name})
	obj_create(res)
	obj_setownproperty(${res} "val1" "the value")
	obj_getownproperty(${res} val "val2")

	assert("property should have been set to 'the value'" ${val} STREQUAL "NOTFOUND")
endfunction()



test_register(shouldDeleteAObject)
function(${current_test_name})
 obj_create(res)
 obj_delete(${res})
 assert("object should have been deleted" NOT EXISTS ${res})
endfunction()

test_register(shouldCreateAEmptyMap)
function(${current_test_name})
  map_create(res)
  assert("should return a mapname ${res}" res)
  map_getkeys( ${res} keys)
  list(LENGTH keys key_count)
  assert("should not have any keys not (${key_count})" key_count EQUAL 0)

  assert("should have created a file" EXISTS ${res})

 obj_gettype(${res} type)
assert_stringequal("should contain map as type" "map" "${type}")
endfunction()

test_register(shouldSetAndGetKeyValue)
function(${current_test_name})
 map_create(res)
 map_set(${res} "val1" "value or something")
 map_get(  ${res} val "val1")
 assert("should have gotten the previously set value not '${val}'" ${val} STREQUAL "value or something")
endfunction()


test_register(shouldSetObjectProperty)
function(${current_test_name})
 obj_create(res)
 obj_set(${res} "val1" "val123")
 assert("property should exist" EXISTS "${res}/val1")

endfunction()

test_register(shouldGetObjectProperty)
function(${current_test_name})
 obj_create(res)
 obj_set(${res} "val1" "val123")
 obj_get( ${res} val "val1")
 assert("property should be gotten" val)
endfunction()

test_register(shouldGetEmptyValueOnUndefinedProperty)
function(${current_test_name})
 obj_create(res)
 obj_get( ${res} val "val1")
 assert_stringequal("should return not found if property is not set" "NOTFOUND"  ${val})
  
endfunction()

test_register(shouldReturnTrueIfIsType)
function(${current_test_name})
 obj_create(res)
 obj_settype(${res} "mytype")
 obj_istype( ${res} ok "mytype")
 assert("should return true" ok)
endfunction()


test_register(shouldGetAndSetLists)
function(${current_test_name})
 obj_create(res)
 obj_set(${res} "val1" a b c d e f g)
 obj_get( ${res} val "val1")
 list(LENGTH val val_len)
 assert("should return the correct number of items in list not ${val_len} ${res}" ${val_len} EQUAL 7)
endfunction()

test_register(shouldBindAndCallFunction)
function(${current_test_name})
 function(myfoo this val1 val2)
   set(${val1} ${this} PARENT_SCOPE)
   set(${val2} ${this} PARENT_SCOPE)
 endfunction()

 obj_create(res)
 obj_bindcall(${res} myfoo a1 a2)
 assert_stringequal("output arg 1 should equal input " ${a1} ${res})
 assert_stringequal("output arg 2 should equal input " ${a2} ${res})
endfunction()

test_register(shouldSetAndCallFunction)
function(${current_test_name})
	obj_create(res)
	obj_set(${res} "foo" RAW "function(foo this resa resB)\n set(\${resa} \${this} PARENT_SCOPE) \n set(\${resB} \${this} PARENT_SCOPE) \n endfunction()")
	obj_callmember(${res} "foo" oot oot2)

	assert_stringequal("should have succesfully called object function 1 " ${oot}   ${res})
	assert_stringequal("should have succesfully called object function 2" ${oot2}   ${res})
endfunction()

test_register(shouldCreateCustomIdObject)
function(${current_test_name})
 	obj_create(res "${cutil_temp_dir}/Main.obj")
 	assert("should return id" res)
 	assert("should have created folder for object " EXISTS "${cutil_temp_dir}/Main.obj")
 	obj_delete(${res})
endfunction()


test_register(basicPrototypicalInheritance)
function(${current_test_name})
  obj_create(base)
  obj_create(derived)


  obj_setprototype(${derived} ${base})



  obj_set(${base} prop1 "base prop1")
  obj_set(${base} prop2 "base prop2")
  obj_set(${derived} prop2 "derived prop2")
  obj_set(${derived} prop3 "derived prop3")

  obj_get(${base} val1 prop1)
  obj_get(${base} val2 prop2)
  obj_get(${derived} val3 prop2)
  obj_get(${derived} val4 prop3)
  obj_get(${base} val5 prop3)

  assert("true" val1)
  assert("true" val2)
  assert("true" val3)
  assert("true" val4)
  assert("false" NOT val5)


  assert_stringequal("true" "base prop1" ${val1})
  assert_stringequal("true" "base prop2" ${val2})
  assert_stringequal("true" "derived prop2" ${val3})
  assert_stringequal("true" "derived prop3" ${val4})

endfunction()

	
test_register(simpleInheritanceScenario)
function(${current_test_name})
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


endfunction()

endmacro()