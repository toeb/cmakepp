
  function(define_test_function name parse_function_name)
    eval("
      function(${name} expected)
        set(args \${ARGN})
        list_extract_flag(args --print)
        ans(print)
        m(parsed = \"\${expected}\")
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

        if(\"\${expected}_\" STREQUAL \"\${uut}_\")
          return()
        endif()


        map_iterator(\${expected})
        ans(it)
        while(true)
          map_iterator_break(it)
          map_tryget(\${uut} \${it.key})
          ans(actual_value)
          assert(\${actual_value} \${it.value} EQUALS)
        endwhile()
      endfunction()

    ")
    return()
  endfunction()
