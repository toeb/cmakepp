function(test)


function(f1)
  return("hello")
endfunction()
obj_new(CompositeHandler)
ans(handler)
call(${handler}())
ans(res)
assert(NOT res)



obj_new(CompositeHandler)
ans(handler)
obj_callmember(${handler} add f1)
call(${handler}())
ans(res)
assert("${res}" STREQUAL "hello")


function(f2)
  return()
endfunction()

obj_new(CompositeHandler)
ans(handler)
call(handler.add(f2))
ans(res)
assert(res)
call(handler.add(f1))
ans(res)
assert(res)
call(handler())
ans(res)
assert("${res}" STREQUAL "hello")





endfunction()