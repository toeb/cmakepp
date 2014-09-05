function(test)
  function(fdl input)
    language("${base_dir}/resources/function_definition_language.json")
    ans(lang)
    map_new()
    ans(ctx)
    map_set(${ctx} input "${input}")
    map_set(${ctx} def "signature")
    obj_setprototype(${ctx} "${lang}")
    lang(output ${ctx})
    ans(res)
    return_ref(res)
  endfunction()



  function(def definition)
    set(args ${ARGN})
    # get dynamic flag
    list_contains(args --dynamic)
    ans(define_dynamic)

    # parse definition of function
    fdl("${definition}")
    ans(def)
    if(NOT def)
      message(FATAL_ERROR "invalid definition: '${definition}'")
    endif()

    # get definition name
    map_tryget(${def} name)
    ans(name)

    map_tryget(${def} arguments)
    ans(arguments)


    set(arguments_string)
    set(only_required true)
    foreach(argument ${arguments})
      map_tryget(${argument} required)
      ans(required)
      if(NOT required)
        set(only_required false)
      endif()
      map_tryget(${argument} name)
      ans(arg_name)

      map_tryget(${argument} type)
      ans(arg_type)


      set(arguments_string "${arguments_string} ${arg_name}")

    endforeach()

    message("argstring ${arguments_string}")


    # if function is to be a dynamic definition create a new function symbol
    if(define_dynamic)
      function_new()
      ans(outer)
    else()
      set(outer ${name})
    endif()

    # define inner function dynamically
    function_new()
    ans(inner)

    set(str "
      function(${outer})
        set(definition ${def})
        set(args \${ARGN})
        list_extract_flag(args --reflect)
        ans(refl)
        if(refl)
          return(\${definition})
        endif()
        ${inner}(\${args})
      endfunction()

      ")
    set_ans("")
    eval("${str}")
    set(${name} ${inner} PARENT_SCOPE)
    return_ref(outer)
  endfunction()


  function(function_print_info info)
    map_tryget(${info} arguments)
    ans(args)
    set(args_str)
    foreach(arg ${args})
      map_tryget(${arg} required)
      ans(arg_required)
      if(arg_required)

        map_format("<{arg.name}>")
        ans(arg_str)
      else()
        map_format("[{arg.name}]")
        ans(arg_str)
      endif()
        set(args_str "${args_str} ${arg_str}")
    endforeach()
    if(NOT "_${arg_str}" STREQUAL "_")
      string(SUBSTRING "${args_str}" 1 -1 args_str)
    endif()
    message(FORMAT "{info.name}(${args_str})")
  endfunction()


  def("my_test(<arg1> [asd])")

  function(${my_test})
    messagE("hello ${definition}" )
#    json_print(${definition})
  endfunction() 


  my_test(--reflect)
  ans(defi)
  function_print_info(${defi})

json_print(${defi})
endfunction()