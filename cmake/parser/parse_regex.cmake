
  function(parse_regex rstring)
    # deref rstring
    ref_get(${rstring})
    ans(str)
    # get regex from defintion
    map_get(${definition} regex)
    ans(regex)

    #message("parsing '${parser_id}' parser (regex: '${regex}') for '${str}'")
    # try to take regex from string
#    message("str is ${str} and regex is '${regex}'")
    
    map_tryget(${definition} ignore_regex)
    ans(ignore_regex)
   # message("ignore: ${ignore_regex}")
    list(LENGTH ignore_regex len)
    if(len)
   # message("ignoring ${ignore_regex}")
        string_take_regex(str "${ignore_regex}")
    endif()

    string_take_regex(str "${regex}")
    ans(match)


    # if not success return
    list(LENGTH match len)
    if(NOT len)
      return()
    endif()


    map_tryget(${definition} replace)
    ans(replace)
    if(replace)        
        string_eval("${replace}")
        ans(replace)
        #message("replace ${replace}")
        string(REGEX REPLACE "${regex}" "${replace}" match "${match}")
        #message("replaced :'${match}'")
    endif()


    # if success set rstring to rest of string
    ref_set(${rstring} "${str}")

    # return matched element
    return_ref(match)
  endfunction()