function(test)


  promise(() return(20) )
  ans(p1)

  promise_start("${p1}")

  message("p1 ${p1}")
  promise_wait("${p1}")
  ans(p2)

  json_print(${p1})

  message("p1 ${p2}")

  return()



  promise_from_anonymous(() message("before_start") timer_start(t1))
  ans(p3)
  message("1 ${p3}")
  promise_start(${p3})
  promise_then_execute(${p3}  COMMAND ${CMAKE_COMMAND} -E sleep 1)
  ans(p3)
  message("1 ${p3}")

  promise_wait(${p3})
  ans(result)


  return()


  promise_then_anonymous(${p3} () message(after_start) timer_print_elapsed(t1) json_print(\${ARGN}))
  ans(p3)



return()

  promise_from_anonymous(() return(1))
  ans(uut)

  
  promise_start(${uut})
  
  promise_wait(${uut})
  ans(value)

  assert(${value} STREQUAL 1) 



  ##
  promise_then_anonymous("1" () math(EXPR i "\${ARGN} + \${ARGN}") return(\${i}))
  ans(promise)
  promise_then_anonymous("${promise}" () math(EXPR i "\${ARGN} + \${ARGN}") return(\${i}))
  ans(promise)
  tqr()
  assertf("{promise.value}" STREQUAL "4")


  promise_new()
  ans(promise)
  assert(promise)
  promise_state("${promise}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "pending")
  assertf({promise.__keys__} CONTAINS promise_state)


  promise_from_value()
  ans(promise)
  assert(promise)
  promise_state("${promise}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "resolved")
  assertf({promise.__keys__} CONTAINS promise_state)


  promise_from_task()
  ans(promise)
  assert(NOT promise)


  task_anonymous("" () return(1))
  ans(task)
  promise_from_task("${task}")
  ans(promise)
  assert(promise)  
  assertf({promise.__keys__} CONTAINS promise_state)
  assertf({promise.task} STREQUAL "${task}")


  function(test_callable)
    return(1)
  endfunction()
  promise_from_callable(test_callable)
  ans(promise)
  assert(promise)
  is_promise("${promise}")
  ans(is_promise)
  assert(is_promise)
  promise_state("${promise}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "pending")


  promise_from_anonymous(() return(2))
  ans(promise)
  assert(promise)
  is_promise("${promise}")
  ans(is_promise)
  assert(is_promise)
  promise_state("${promise}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "pending")


  promise("hello")
  ans(promise)
  assert(promise)
  is_promise("${promise}")
  ans(is_promise)
  assert(is_promise)
  promise_state("${promise}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "resolved")
  assertf({promise.value} STREQUAL "hello") 


  promise("hello")
  ans(promise)
  promise_from_anonymous(() message(\${ARGN}) return(\${ARGN}))
  ans(continuation)
  continuation_resolve("${promise}" "${continuation}")
  ans(success)
  assert(success)
  promise_state(${continuation})
  ans(promise_state)
  assert("${promise_state}" STREQUAL "pending")
  task_invoke("${success}")
  promise_state("${continuation}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "resolved")
  assertf({continuation.value} STREQUAL "hello")

  promise("hello2")
  ans(promise)
  promise_new()
  ans(continuation)
  continuation_resolve("${promise}" "${continuation}")
  ans(success)
  promise_state("${continuation}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "pending")
  task_invoke("${success}")
  promise_state("${continuation}")
  ans(promise_state)
  assert("${promise_state}" STREQUAL "resolved")
  assertf({continuation.value} STREQUAL "hello2")



  promise("hello1")
  ans(promise)
  promise("hello2")
  ans(continuation)
  continuation_resolve("${promise}" "${continuation}")
  ans(res)
  assert(NOT res)


  
  promise_all(a b c)
  ans(promise)
  promise_wait("${promise}")
  ans(res)
  assert(${res} EQUALS a b c)



  promise_execute(COMMAND ${CMAKE_COMMAND} -E sleep 3)
  ans(p1)

  promise_execute(COMMAND ${CMAKE_COMMAND} -E sleep 4)
  ans(p2)


  promise_from_anonymous(() message("before_start") timer_start(t1))
  ans(p3)
  promise_start(${p3})
  promise_wait(${p3})
  promise_then_execute(${p3}  COMMAND ${CMAKE_COMMAND} -E sleep 1)
  ans(p3)


  promise_then_anonymous(${p3} () message(after_start) timer_print_elapsed(t1) json_print(\${ARGN}))
  ans(p3)
  promise_then_anonymous(${p3} () message(number3finished))
  ans(p3)

  promise_all("${p1}" "${p2}" "${p3}")
  ans(p4)
  promise_wait("${p4}")



  


return()
endfunction()