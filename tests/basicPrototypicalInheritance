
function(basicPrototypicalInheritance)
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

  assert( val1)
  assert( val2)
  assert( val3)
  assert( val4)
  assert( NOT val5)


  assert("base prop1" STREQUAL "${val1}")
  assert("base prop2" STREQUAL "${val2}")
  assert("derived prop2" STREQUAL "${val3}")
  assert("derived prop3" STREQUAL "${val4}")

endfunction()