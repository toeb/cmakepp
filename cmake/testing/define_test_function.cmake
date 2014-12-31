
  function(define_test_function name parse_function_name)
    eval("
      function(${name} expected)
        set(args \${ARGN})
        list_extract_flag(args --print)
        ans(print)
        mm(parsed = \"\${expected}\")
        if(parsed)
          set(expected \${parsed})
        endif()
        #if(NOT expected)
        #  message(FATAL_ERROR \"invalid expected value\")
        #endif()
        ${parse_function_name}(\${args})
        ans(uut)

        if(print)
          json_print(\${uut})
        endif()


        
        map_match(\"\${uut}\" \"\${expected}\")
        ans(res)
        assert(res MESSAGE \"values do not match\")
      endfunction()

    ")
    return()
  endfunction()
