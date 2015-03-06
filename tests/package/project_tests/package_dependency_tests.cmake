function(test)

  function(test_qm2)
    data(${ARGN})
    ans(data)

    timer_start(qm1)
    qm_serialize(${data})
    ans(qmdata)
    timer_print_elapsed(qm1)


    timer_start(qm2)
    qm2_serialize(${data})
    ans(res)
    timer_print_elapsed(qm2)

    timer_start(qm2_des)
    qm2_deserialize("${res}")
    timer_print_elapsed(qm2_des)


    timer_start(qm1_des)
    qm_deserialize("${qmdata}")
    timer_print_elapsed(qm1_des)
    #message("${res}")
    return_ref(res)
  endfunction()

  test_qm2("kabc")
  test_qm2(a b c)
  test_qm2()
  test_qm2("{}")
  ans(lala)
  test_qm2("{a:{b:'asdasd'},c:'kk'}")

  qm2_deserialize("${lala}")


    
  map_new()
  ans(m1)
  map_set(${m1} a ${m1})

  qm2_serialize("${m1}")
  ans(res)
  #message("${res}")
  qm2_deserialize("${res}")
  ans(res)
  map_tryget(${res} a)
  ans(res2)
  ## check if cycles work
  assert(${res} STREQUAL ${res2})
  test_qm2("{a:{b:{b:{b:{b:{b:{b:{b:{b:{b:{b:{b:{b:true}}}}}}}}}}}},c:'kk'}")





endfunction()