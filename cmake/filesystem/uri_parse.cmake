  ## parses an uri
  ## input can be any path or uri
  ## whitespaces in segments are allowed if string is delimited by double or single quotes(non standard behaviour)
  ##{
  #  scheme,
  #  net_root: # is // if the uri is a net uri
  #  authority: # is the authority part if uri has a net_root
  #  abs_root: # is / if the uri is a absolute path
  #  segments: # an array of uri segments (folder)
  #  file: # the last segment 
  #  file_name: # the last segment without extension 
  #  extension: # extension of file 
  #  rest: # the ret of the input string which is not part of the uri
  #  query: # the query part of the uri 
  #  fragment # fragment part of uri
  # }
  ##
  ##
  ##
  function(uri_parse str)

    set(lowalpha "[a-z]")
    set(upalpha "[A-Z]")
    set(digit "[0-9]")
    set(alpha "(${lowalpha}|${upalpha})")
    set(alphanum "(${alpha}|${digit})")

    set(reserved "[\;\\/\\?:@&=\\+\\$,]")
    set(reserved_no_slash "[\;\\?:@&=\\+\\$,]")
    set(mark "[\\-_\\.!~\\*'\\(\\)]")
    set(unreserved "(${alphanum}|${mark})")
    set(hex "[0-9A-Fa-f]")
    set(escaped "%${hex}${hex}")


    set(uric "(${reserved}|${unreserved}|${escaped})")
    set(uric_so_slash "${unreserved}|${reserved_no_slash}|${escaped}")

    
    set(scheme_specific_part)



    set(scheme "((${alpha})(${alpha}|${digit}|[\\+\\-\\.])*)")
    set(abs_path "\\/${path_segments}")
    set(net_path "\\/\\/${authority}(${abs_path})?")
    


    set(opaque_part "(${uric_so_slash})*")

    set(path "${abs_path}|${opaque_part}")
    set(hier_part)
    set(rest)

    set(input)

    string_take_whitespace(str)

    string_take_delimited(str \")
    ans(double_quote_delimited)

    set(delimited false)
    # delimited string
    if(NOT "${double_quote_delimited}_" STREQUAL "_")
      set(rest "${str}")
      set(str "${double_quote_delimited}")
      set(delimited "\"${double_quote_delimited}\"")
    else()
      string_take_delimited(str "'")
      ans(single_quote_delimited)
      if(NOT "${single_quote_delimited}_" STREQUAL "_")
        set(rest "${str}")
        set(str "${single_quote_delimited}")
        set(delimited "'${single_quote_delimited}'")
      endif()
    endif()
    # if string is delimited encode whitespace 
    if(delimited)
      uri_encode("${str}" 32)
      ans(str)
    endif()

    set(url_string ${str})



    string_take_whitespace(str)


    # replace backward slash
    string(REPLACE \\ / str "${str}")

    # scheme
    string_take_regex(str "${scheme}:")
    ans(scheme)
    set(has_scheme false)
    if(NOT "${scheme}_"  STREQUAL _)
      set(has_scheme true)
      string_slice("${scheme}" 0 -2)
      ans(scheme)
    endif()

    # net_root
    string_take_regex(str "//")
    ans(net_root)

    set(abs_root)
    if(NOT net_root)
      # abs_root
      string_take_regex(str "/")
      ans(abs_root)
    endif()


    set(segment_char "[^?#/ ]")
    set(segments)
    while(true) 
      string_take_regex(str "${segment_char}+" )
      ans(segment)
      string_take_regex(str "/")
      if("${segment}_" STREQUAL "_")
        break()
      endif()
      list(APPEND segments "${segment}")
    endwhile()


    set(authority)
    if(net_root)
      list_pop_front(segments)
      ans(authority)


      #set(bkp "${authority}")

      #string_take_regex(authority "${unreserved}|${escaped}|[\\$,\;:@&=\\+]")
      #ans(reg_name)

      #set(authority "${bkp}")

      set(ipv4_group "([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])")
      set(ipv4_regex "${ipv4_group}\\.${ipv4_group}\\.${ipv4_group}\\.${ipv4_group}")

      set(domainlabel "${alphanum}(${alphanum}|\\-)*")
      set(hostname_regex "${domainlabel}")
      set(host "${ipv4_regex}|${hostname_regex}")
      set(server_regex "(${user_info}@)?${host}:${port}")
      #string_take_regex(authority )

    endif()





    set(file_name)
    set(file)
    set(extension)
    if(NOT "${segments}_" STREQUAL "_")
      list_get(segments -2)
      ans(file)
      string(REGEX MATCH "[^\\.]+$" extension "${file}")
      
      if("${extension}" STREQUAL "${file}")
        set(file_name "${file}")
        set(extension "")
      elseif(NOT "${extension}_" STREQUAL "_")
        string(LENGTH ".${extension}" len)
        string_slice("${file}" 0 "-${len}" )
        ans(file_name)
        if(NOT "${file_name}_" STREQUAL "_")
          string_slice("${file_name}" 0 -2)
          ans(file_name)
        endif()
      endif()
    endif()

    string_take_regex(str "\\?${uric}*")
    ans(query)
    if(NOT "${query}_" STREQUAL "_")
      string_slice("${query}" 1 -1)
      ans(query)
    endif()

    string_take_regex(str "#${uric}*")
    ans(fragment)

    if(NOT "${fragment}_" STREQUAL "_")
      string_slice("${fragment}" 1 -1)
      ans(fragment)
    endif()

    set(rest "${str}${rest}")


    map_capture_new(scheme net_root abs_root segments file file_name extension authority rest query fragment delimited url_string input)
    ans(res)
      
    return_ref(res)

  endfunction()