function(test)
return()
# @ todo complete bulk glob
  function(bulk_glob path)
    path(path)
  endfunction()


  message("${test_dir}")
  mkdir("${test_dir}/fs")
  pushd("${test_dir}/fs")

  touch("abc.txt")
  touch("abc.xls")
  touch("help.txt")
  touch("help.bat")
  touch("dir1/test.txt")
  touch("dir1/main.h")
  touch("dir1/main.cpp")
  touch("dir2/head1.h")
  touch("dir2/head2.h")
  touch("dir2/head3.h")
  popd()

  
  file(GLOB_RECURSE paths RELATIVE "${test_dir}/fs" "${test_dir}/fs/**")
  dbg(paths)




 # transforms a glob expression into its equivalent regular expression
  function(glob_to_regex glob_expr)
    # transferred to cmake from http://stackoverflow.com/questions/11276909/how-to-convert-between-a-glob-pattern-and-a-regexp-pattern-in-ruby
    string(LENGTH "${glob_expr}" len)
    set(i 0)
    set(res)
    set(escaping false)
    set(in_curlies 0)
    while("${i}" LESS "${len}")
      string(SUBSTRING "${glob_expr}" "${i}" 1 char)
      if(escaping)
        set(escaping false)
        set(res "${res}${char}")
      elseif("${char}" STREQUAL "*")
        set(res "${res}.*")
      elseif("${char}" STREQUAL "?")
        set(res "${res}.")
      elseif("${char}" STREQUAL ".")
        set(res "${res}\\.")
      elseif("${char}" STREQUAL "{")
        math(EXPR in_curlies "${in_curlies} + 1")
        set(res "${res}(")
      elseif("${char}" STREQUAL "}")
        if(in_curlies GREATER 0)
          math(EXPR in_curlies "${in_curlies} - 1")
          set(res "${res})")
        else()
          set(res "${res}${char}")
        endif()
      elseif("${char}" STREQUAL ",")
        if("${in_curlies}" GREATER 0)
          set(res "${res}|")
        else()
          set(res "${res}${char}")
        endif()
      elseif("${char}" STREQUAL "\\")
        set(escaping true)
        set(res "${res}\\")
      else()
        set(res "${res}${char}")
      endif()

      math(EXPR i "${i} + 1")
    endwhile()

    return_ref(res)

  endfunction()


  glob_to_regex("*.{h,cpp,c}")
  ans(res)

  # splits the list at the given pivot element the pivot element is not added to result, 
  # lst = "1;2;3;4;4;5;6;7" 
  #list_split_at(lst lhs rhs 4) -> lhs= "1;2;3" rhs = "4;5;6;7"
  # returns true if the pivot element was found false otherwise
  function(list_split_at lst left right pivot)
    list(FIND ${lst} "${pivot}" idx)
    list_split("${lst}" ${left} ${right})
    # dont forget to remove pivot element from list
 #   list_split()
  endfunction() 

  set(lstA 1 2 3 4 4 5 6 7)
  list_split_at(lstA lhs rhs 4)
  ans(res)
  assert(res)

  function(regex_ignore str)
    set(args ${ARGN})
    list_split_at(args --ignore)
    ans(res)
    lst(${res} 0)
    ans(lft)
    lst(${res} 1)
    ans(rt)
  endfunction()

  # returns all strings from list that match the specified regexes
  # ignores all matches which match regexes following the --ignore flag
  # list_match("tobi;Tobias,Tom;toto;Katha;Janis" a --ignore ^to) --> "Katha;Janis"
  function(list_match string)
    cmake_parse_arguments("" "" "" "--ignore" ${ARGN})
    set(positive "${_UNUSED_ARGUMENTS}")
    set(negative "${_--ignore}")
    set(args ${ARGN})
    
    foreach(arg ${args})
      if("${arg}" MATCHES "^\\!")

      endif()
    endforeach()

    foreach(string ${strings})
      if("${path}" MATCHES "${positive}")
        if(NOT "${negative}_"  STREQUAL "_")
          if(NOT "${path}" MATCHES "${negative}")
            list(APPEND results "${path}")
          endif()
        else()
          list(APPEND results "${path}")
        endif()
      endif()
    endforeach()
  endfunction()


  message("res is '${res}'")



endfunction()