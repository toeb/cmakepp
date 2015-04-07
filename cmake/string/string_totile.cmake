## `(<str:<string>>)-><string>`
##
## Transforms the input string to title case.
## Tries to be smart and keeps some words small.
##
## **Examples**<%
##  set(my_title "the function string_totitle works")
##  string_totile("${my_title}")
##  ans(res)
## %>
##
##
function(string_totitle str)
  set(small a an and as at but by en for if in of on or the to via vs v v. vs. A An And As At But By En For If In Of On Or The To Via Vs V V. Vs.)
  set(other "[^ ]+")
  set(ws "[ ]+")
  set(is_subsentence true)

  string_encode_list(${str})
  ans(str_encoded)
  string(REGEX MATCHALL "(${ws})|(${other})" tokens "${str_encoded}")
  
  foreach(token ${tokens})
    if("${token}" MATCHES  "^([^a-zA-Z0-9]*)([a-zA-Z])([a-z]*[']?[a-z]*)([:?!',]*)$")
      set(pre ${CMAKE_MATCH_1})
      set(first_letter ${CMAKE_MATCH_2})
      set(lc_letters ${CMAKE_MATCH_3})
      set(post ${CMAKE_MATCH_4})
      
      list(FIND small "${first_letter}${lc_letters}" index)
      if(index GREATER -1)
         if(is_subsentence)
             string(TOUPPER ${first_letter} first_letter)
        else()
             string(TOLOWER ${first_letter} first_letter)
        endif()
      else()
         string(TOUPPER ${first_letter} first_letter)
      endif()
      
      if("${post}" MATCHES "[^,')]")
        set(is_subsentence true)
      else()
        set(is_subsentence false)
      endif()

      set(token "${pre}${first_letter}${uc_letters}${lc_letters}${post}")
    endif()

    set(res "${res}${token}")
  endforeach()

  return_ref(res)
endfunction()
