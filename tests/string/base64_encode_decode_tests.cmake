function(test)


  function(base64_encode str)
    string(LENGTH "${str}" len)
    math(EXPR len "${len} - 1")
    foreach(i RANGE 0 len)
      string_char_at("${str}" ${i})
      ans(c)

      set(result)

      foreach(i RANGE 1 255)
        string(ASCII "${i}" char)

        if("${char}_" STREQUAL "${c}_")

          set(result "${result}")
        endif()
      endforeach()

    endforeach()
  endfunction()

  function(base64_decode str)

  endfunction()


endfunction()