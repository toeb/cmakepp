function(interpret_separation tokens separator_type)    
    
    ## initialize variables
    set(elements)         # stores all single elements
    set(current_tokens)   # set list of current tokens
    set(static true)      # set if all elements are static
    set(argument)         # set derived argument
    set(code)             # set derived code


    ## loop through all tokens 
    ## and collection non-separators inside `current_tokens`
    ## if a separator or `end` is reached parse the `current_tokens`
    ## to obtain an element
    list(APPEND tokens end)
    foreach(token ${tokens})
      map_tryget("${token}" type)
      ans(type)
      if("${token}" STREQUAL "end" OR "${type}" MATCHES "^(${separator_type})$")
        interpret_expression("${current_tokens}" ${ARGN})
        ans(element)

        if(NOT element)
            message("failed to interpret element")
            return()
        endif() 
        set(current_tokens)
        list(APPEND elements "${element}")

        map_tryget("${element}" static)
        ans(is_static)

        if(NOT is_static)
          set(static false)
        endif()

        map_tryget("${element}" code)
        ans(element_code)

        map_tryget("${element}" argument)
        ans(element_argument)

        set(code "${code}${element_code}")
        set(argument "${argument} ${element_argument}")

        if("${token}" STREQUAL "end")
          break()
        endif()
      else()
        list(APPEND current_tokens "${token}")
      endif()
    endforeach()
    
    # remove leading whitespace
    string(SUBSTRING "${argument}" 1 -1 argument)

    map_new()
    ans(ast)
    map_set("${ast}" type separation)
    map_set("${ast}" elements "${elements}")
    map_set("${ast}" code "${code}")
    map_set("${ast}" argument "${argument}")
    map_set("${ast}" static "${static}")
    return(${ast})
endfunction()
