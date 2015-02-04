
  function(range_parse)
    string(REPLACE " " ";" range "${ARGN}")
    string(REPLACE "," ";" range "${range}")

    string(REPLACE "(" ">" range "${range}")
    string(REPLACE ")" "<" range "${range}")
    string(REPLACE "[" "<" range "${range}")
    string(REPLACE "]" ">" range "${range}")

    list(LENGTH range group_count)

    set(ranges)
    if(${group_count} GREATER 1)
      foreach(group ${range})
        range_parse("${group}")
        ans(current)
        list(APPEND ranges "${current}")
      endforeach()
      return_ref(ranges)
    endif()


    set(default_begin_inclusivity)
    set(default_end_inclusivity)



    string(REGEX REPLACE "([^<>])+" "_" inclusivity "${range}")
    set(inclusivity "${inclusivity}___")
    string(SUBSTRING ${inclusivity} 0 1 begin_inclusivity )
    string(SUBSTRING ${inclusivity} 1 1 end_inclusivity )
    string(SUBSTRING ${inclusivity} 2 1 three )
    if(${end_inclusivity} STREQUAL _)
      set(end_inclusivity ${three})
    endif()



    if("${begin_inclusivity}" STREQUAL "<")
      set(begin_inclusivity true)
    elseif("${begin_inclusivity}" STREQUAL ">")
      set(begin_inclusivity false)
    else()
     set(begin_inclusivity true)
     set(default_begin_inclusivity true) 
    endif()

    if("${end_inclusivity}" STREQUAL "<")
      set(end_inclusivity false)
    elseif("${end_inclusivity}" STREQUAL ">")
      set(end_inclusivity true)
    else()
      set(end_inclusivity true)
      set(default_end_inclusivity true)
    endif()

    # if("${range}" MATCHES "INC_BEGIN")
    #  set(begin_inclusivity true)
    # elseif("${range}" MATCHES "EXC_BEGIN")
    #   set(begin_inclusivity false)
    # else()
    #    set(begin_inclusivity true)
    #    set(default_begin_inclusivity true)
    # endif()

    #  if("${range}" MATCHES "INC_END")
    #    set(end_inclusivity true)
    #  elseif("${range}" MATCHES "EXC_END")
    #    set(end_inclusivity false)
    #  else()
    #    set(default_end_inclusivity true)
    #    set(end_inclusivity true)
    #  endif()

    # # #message("inc ${range} ${begin_inclusivity} ${end_inclusivity}")

    #  string(REPLACE "INC_BEGIN" "" range "${range}")
    #  string(REPLACE "INC_END" "" range "${range}")
    #  string(REPLACE "EXC_BEGIN" "" range "${range}")
    #  string(REPLACE "EXC_END" "" range "${range}")
    string(REGEX REPLACE "[<>]" "" range "${range}")

    if("${range}_" STREQUAL "_")
      set(range "n:n:1")
      if(default_end_inclusivity)
        set(end_inclusivity false)
      endif()
    endif()

    if("${range}" STREQUAL "*")
      set(range "0:n:1")
    endif()

    if("${range}" STREQUAL ":")
      set(range "0:$:1")
    endif()


    

    
    string(REPLACE  ":" ";" range "${range}")
    

    list(LENGTH range part_count)
    if(${part_count} EQUAL 1)
      set(range ${range} ${range} 1)
    endif()

    if(${part_count} EQUAL 2)
      list(APPEND range 1)
    endif()

    list(GET range 0 begin)
    list(GET range 1 end)
    list(GET range 2 increment)
    ##message("partcount ${part_count}")
    if(${part_count} GREATER 3)
      list(GET range 3 begin_inclusivity)
    endif()
    if(${part_count} GREATER 4)
      list(GET range 4 end_inclusivity)
    endif()

    # #message("inc ${range} ${begin_inclusivity} ${end_inclusivity}")


    if((${end} LESS ${begin} AND ${increment} GREATER 0) OR (${end} GREATER ${begin} AND ${increment} LESS 0))
      return()
    endif()

    set(reverse false)
    if(${begin} GREATER ${end})
      set(reverse true)
    endif()

    if(${begin} STREQUAL -0)
      set(begin $)
    endif()

    if(${end} STREQUAL -0)
      set(end $)
    endif()


    set(begin_negative false)
    set(end_negative false)
    if(${begin} LESS 0)
      set(begin "($${begin})")
      set(begin_negative true)
    endif()
    if(${end} LESS 0)
      set(end "($${end})")
      set(end_negative true)
    endif()

    if("${begin}" MATCHES "[\\-\\+]")
      set(begin "(${begin})")
    endif()
    if("${end}" MATCHES "[\\-\\+]")
      set(end "(${end})")
    endif()


    if(NOT reverse)
      set(length "${end}-${begin}")
      if(end_inclusivity)
        set(length "${length}+1")
      endif()
      if(NOT begin_inclusivity)
        set(length "${length}-1")
      endif()
    else()
      #message("reverse begin ${begin} end ${end}")
      set(length "${begin}-${end}")
      if(begin_inclusivity)
        set(length "${length}+1")
      endif()
      if(NOT end_inclusivity)
        set(length "${length}-1")
      endif()
    endif()
    string(REPLACE "n-n" "0" length "${length}")
    string(REPLACE "n-$" "1" length "${length}")
    string(REPLACE "$-n" "0-1" length "${length}")
    string(REPLACE "$-$" "0" length "${length}")
    #message("length ${length}")

    if("${increment}" GREATER 1)
      set(length "(${length}-1)/${increment}+1")
    elseif("${increment}" LESS -1)
      set(length "(${length}-1)/(0-(0${increment}))+1")
    elseif(${increment} EQUAL 0)
      set(length 1)
    endif()
    #message("length ${length}")
    if(NOT "${length}" MATCHES "\\$|n" )
      math(EXPR length "${length}")
    else()
       # 
    endif()
    set(range "${begin}:${end}:${increment}:${begin_inclusivity}:${end_inclusivity}:${length}:${reverse}")
    #message("range '${range}'\n")
 
    return_ref(range)
  endfunction()