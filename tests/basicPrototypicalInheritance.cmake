function(basicPrototypicalInheritance)
  obj_create(base)
  obj_create(derived)


  obj_setprototype(${derived} ${base})



  obj_set(${base} prop1 "base prop1")
  obj_set(${base} prop2 "base prop2")
  obj_set(${derived} prop2 "derived prop2")
  obj_set(${derived} prop3 "derived prop3")

  obj_get(${base}  prop1)
  ans(val1)
  obj_get(${base}  prop2)
  ans(val2)
  obj_get(${derived}  prop2)
  ans(val3)
  obj_get(${derived}  prop3)
  ans(val4)
  obj_get(${base}  prop3)
  ans(val5)

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