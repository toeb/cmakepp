function(test)

  ##{
  #  name: type name,
  #  properties: [
  #    <property definition>
  #  ]
  #
  # }
  function(type_def input)
    obj("${input}")
    ans(type)

    if(NOT type)
      if("${input}" MATCHES "^[a-zA-Z_][a-zA-Z_0-9]*$")
        obj("{name:$input}")
        ans(type)
      else()
        return()
      endif()
    endif()




    map_tryget(${type} name)
    ans(name)

    
    if(NOT name)
      return()
    endif()

    set(flags "--${name}")
    map_defaults("${type}" "{
      flags:$flags,
      properties:{}
      }")



    return_ref(type)

  endfunction()

  #{
  #  name:<property name>,
  #  display_name: <string>,
  #  description: <string>
  #  min: [0-*]
  #  max: [0-*]
  #  types: []
  #}
  function(property_def input)
    obj("${input}")
    ans(property)
    if(NOT property)
      if("_${input}" MATCHES "^_[a-zA-Z_][a-zA-Z_0-9]*$")
        obj("{name:$input}")
        ans(property)
      else()
        return()
      endif()
    endif()



    map_tryget(${property} name)
    ans(name)
    if(NOT name)
      return()
    endif()

    set(flag "--${name}")

    map_defaults("${property}" "{
      display_name:$name,
      flags:$flag,
      description:'',
      min:'0',
      max:'*',
      default:'',
      types:'any'
      }")

    return_ans(property)
  endfunction()

  define_test_function(test_uut property_def)
  
  # name test
  test_uut("{name:'asd'}" "asd")
  test_uut("{name:'asd'}" "{name:'asd'}")
  test_uut("" "{noname:'asd'}")

  # display_name test
  test_uut("{display_name:'asd'}" "asd")
  test_uut("{display_name:'asd'}" "{name:'asd'}")

  # multiplicity_test
  test_uut("{min:0,max:'*'}" "asd")
  test_uut("{min:0,max:'*'}" "{name:'asd'}")
  test_uut("{min:1,max:'*'}" "{name:'asd', min:1}")
  test_uut("{min:0,max:4}" "{name:'asd', max:4}")
  test_uut("{min:2,max:5}" "{name:'asd', min:2,max:5}")


  # types test
  test_uut("{types:'any'}" "asd")
  test_uut("{types:['int','string']}" "{name:'asd',types:['int','string']}")





  define_test_function(test_uut type_def)


  ## test flags
  test_uut("{flags:'--asd'}" asd)
  test_uut("{flags:'--asd'}" "{name:'asd'}")
  test_uut("{flags:'--asd'}" "{name:'asd', flags:['-a','--asd']}")


  ## name test
  test_uut("{name:'asd'}" asd)
  test_uut("{name:'asd'}" "{name:'asd'}") 
  test_uut("" "{noname:'asd'}")


  ## property test
  test_uut("{properties:{}}" asd)
  test_uut("{properties:{}}" "{name:'asd'}")
  test_uut("{properties:{prop1:{}}}" "{name:'asd', properties:{prop1:'val'}}")

return()


  type("{name:'person',properties:{first_name:'string','last_name':'string'}}")
  ans(type)


  set(structured_data )

  structured_data_parse_list("${type}" --last_name "Becker" --first_name "Tobias")


  return()





endfunction()