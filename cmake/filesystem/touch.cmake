# creates a file or updates the file access time
# *by appending an empty string
function(touch path)

  #if("${CMAKE_MAJOR_VERSION}" LESS 3)
    function(touch path)

      path("${path}")
      ans(path)

      set(args ${ARGN})
      list_extract_flag(args --nocreate)
      ans(nocreate)

      if(NOT EXISTS "${path}" AND nocreate)
        return_ref(path)
      elseif(NOT EXISTS "${path}")
        file(WRITE "${path}" "")        
      else()
        file(APPEND "${path}" "")
      endif()


      return_ref(path)

    endfunction()
  #else()
  #  function(touch path)
  #    path("${path}")
  #    ans(path)
#
#  #    set(args ${ARGN})
#  #    list_extract_flag(args --nocreate)
#  #    ans(nocreate)
#
#
#
#  #    set(cmd touch)
#  #    if(nocreate)
#  #      set(cmd touch_nocreate)
#
#  #    endif()
#
#  #    cmake(-E ${cmd} "${path}" --result)
#  #    ans(res)
#  #    json_print(${res})
#  #    map_tryget(${res} result)
#  #    ans(erro)
#  #    if(erro)
#  #      message(FATAL_ERROR "faild")
#  #    endif()
#  #    return_ref(path)
#  #  endfunction()
  #endif()
  touch("${path}")
  return_ans()
endfunction()

