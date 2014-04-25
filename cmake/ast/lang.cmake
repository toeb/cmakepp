
  function(lang target context)    
    obj_get(${context} phases)
    ans(phases)

   

    # get target value from
    obj_get(${context} "${target}")
    ans(current_target)
    if(NOT current_target)
      message(FATAL_ERROR "missing target '${target}'")
    endif()


    # check if phase
    list_contains(phases "${current_target}")
    ans(isphase)

    # if not a phase just return value
    if(NOT isphase)
      return_ref("current_target")
    endif()


    # target is phase 
    map_tryget("${current_target}" name)
    ans(name)


    # get inputs for current target
    obj_get("${current_target}" "input")
    ans(required_inputs)



    # setup required imports
    map_new()
    ans(inputs)
    foreach(input ${required_inputs})
        lang("${input}" ${context})
        ans(res)
        map_set(${inputs} "${input}" "${res}")
    endforeach()

    # handle function call
    map_tryget("${current_target}" function)
    ans(func)

    # curry function to specified arguments
    curry2("${func}")
    ans(func)

    # compile argument string
    map_keys(${inputs})
    ans(keys)
    set(arguments_string)
    foreach(key ${keys})
      map_tryget(${inputs} "${key}")
      ans(val)
      set(arguments_string "${arguments_string} \"${val}\"")
    endforeach()

    # call curried function - note that context is available to be modified
    set(func_call "${func}(${arguments_string})")
    eval("${func_call}")
    ans(res)
    obj_set(${context} "${target}" "${res}")

    # set single output to return value
    map_tryget(${current_target} output)
    ans(outputs)
    list(LENGTH outputs len)
    if(${len} EQUAL 1)
      set(${context} "${outputs}" "${res}")
    endif()

    map_tryget(${context} "${target}")
    ans(res)

    return_ref(res)
  endfunction()