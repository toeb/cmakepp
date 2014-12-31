

function(uri_parse_authority uri)
  map_get(${uri} authority)
  ans(authority)

  map_get(${uri} net_path)
  ans(net_path)

  ## set authoirty to localhost if no other authority is specified but it is a net_path (starts wth //)
  if("_authority" STREQUAL "_" AND NOT "${net_path}_" STREQUAL "_")
    set(authority localhost)
  endif()

  dns_parse("${authority}")
  ans(dns)

  map_iterator(${dns})
  ans(it)
  while(true)
    map_iterator_break(it)
    if(NOT "${it.key}" STREQUAL "rest")
      map_set(${uri} ${it.key} ${it.value})
    endif()
  endwhile()

  return()

endfunction()
function(uri_parse_scheme uri)
  map_tryget(${uri} scheme)
  ans(scheme)

  string(REPLACE "+" "\;" schemes "${scheme}")
  map_set(${uri} schemes ${schemes})

endfunction()
function(uri_parse_query uri)

endfunction()

  ## expects last_segment property to exist
  ## ensures file_name, file, extension exists
  function(uri_parse_file uri)
    map_get("${uri}" last_segment)
    ans(file)

    if("_${file}" MATCHES "\\.") # file contains an extension
      string(REGEX MATCH "[^\\.]*$" extension "${file}")
      string(LENGTH "${extension}" extension_length)

      if(extension_length)
        math(EXPR extension_length "0 - ${extension_length}  - 2")
        string_slice("${file}" 0 ${extension_length})
        ans(file_name)
      endif()
    else()
      set(file_name "${file}")
      set(extension "")
    endif()
    map_capture(${uri} file extension file_name)
  endfunction()


  function(uri_parse_path uri)
    map_get("${uri}" path)
    ans(path)    

    set(segments)
    set(encoded_segments)
    set(last_segment)
    string_take_regex(path "${segment_separator_char}")
    ans(slash)
    set(leading_slash ${slash})

    while(true) 
      string_take_regex(path "${segment_char}+" )
      ans(segment)

  


      if("${segment}_" STREQUAL "_")
        break()
      endif()

      string_take_regex(path "${segment_separator_char}")
      ans(slash)


      list(APPEND encoded_segments "${segment}")

      uri_decode("${segment}")
      ans(segment)
      list(APPEND segments "${segment}")
      set(last_segment "${segment}")
    endwhile()


    set(trailing_slash "${slash}")


    set(normalized_segments)
    set(current_segments ${segments})   

    while(true)
      list_pop_front(current_segments)
      ans(segment)

      if("${segment}_" STREQUAL "_")
        break()
      elseif("${segment}" STREQUAL ".")

      elseif("${segment}" STREQUAL "..")
        list(LENGTH normalized_segments len)

        list_pop_back(normalized_segments)
        ans(last)
        if("${last}" STREQUAL ".." )
          list(APPEND normalized_segments .. ..)
        elseif("${last}_" STREQUAL "_" )
          list(APPEND normalized_segments ..)
        endif()
      else()
        list(APPEND normalized_segments "${segment}")
      endif()
    endwhile()

    if(("${segments}_" STREQUAL "_") AND leading_slash)
      set(trailing_slash "")
    endif()


    map_capture(${uri} segments encoded_segments last_segment trailing_slash leading_slash normalized_segments)
    return()
  endfunction()
## normalizes the input for the uri
## expects <uri> to have a property called input
## ensures a property called uri is added to <uri> which contains a valid uri string 
function(uri_normalize_input input_uri)
  set(flags ${ARGN})


  # options  
  set(handle_windows_paths true)
  set(default_file_scheme true)
  set(driveletter_separator :)
  set(delimiters "''" "\"\"" "<>")
  set(encode_input 32) # character codes to encode in delimited input
  set(ignore_leading_whitespace true)
  map_get("${input_uri}" input)
  ans(input)

  if(ignore_leading_whitespace)
    string_take_whitespace(input)
  endif()

  set(delimited)
  foreach(delimiter ${delimiters})
    string_take_delimited(input "${delimiter}")
    ans(delimited)
    if(NOT "${delimited}_" STREQUAL "_")
      break()
    endif()
  endforeach()

  set(delimiters "${delimiter}")

    # if string is delimited encode whitespace 
    if(NOT "${delimited}_" STREQUAL "_")
      set(rest "${input}")
      set(input "${delimited}")
      
      if(ignore_leading_whitespace)
        string_take_whitespace(input)
      endif()

      if(encode_input)
        uri_encode("${input}" 32)
        ans(input)
      endif()
    endif()

    

    # the whole uri is delimited by a space or end of string
    string_take_regex(input "${uric}+")
    ans(uri)

    if("${rest}_" STREQUAL "_")
      set(rest "${input}")
    endif()


    set(windows_absolute_path false)
    if(default_file_scheme)
      if(handle_windows_paths)
        # replace backward slash with forward slash
        # for windows paths - non standard behaviour
        string(REPLACE \\ /  uri "${uri}")
      endif()  


      if("_${uri}" MATCHES "^_/" AND NOT "_${uri}" MATCHES "^_//")
        set(uri "file://${uri}")
      endif()

      if("_${uri}" MATCHES "^_[a-zA-Z]:")
        #local windows path no scheme -> scheme is file://
        # <drive letter>: is replaced by /<drive letter>|/
        # also colon after drive letter is normalized to  ${driveletter_separator}
        string(REGEX REPLACE "^_([a-zA-Z]):(.+)" "\\1${driveletter_separator}\\2" uri "_${uri}")
        set(uri "file:///${uri}")
        set(windows_absolute_path true)
      endif()

    endif()
    
    # the rest is not part of input_uri
    map_capture(${input_uri} uri rest delimited_rest delimiters windows_absolute_path)
    return_ref(input_uri)

endfunction()


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
    set(flags ${ARGN})

    list_extract_flag(flags --notnull)
    ans(notnull)
    if(notnull)
      set(notnull --notnull)
    else()
      set(notnull)
    endif()


    regex_table()



    # set input data for uri
    map_new()
    ans(res)

    map_set(${res} input "${str}")


    ## normalize input of uri
    uri_normalize_input("${res}" ${flags})
    map_get("${res}" uri)
    ans(str)

    # scheme
    string_take_regex(str "${scheme_regex}:")
    ans(scheme)

    if(NOT "${scheme}_"  STREQUAL _)
      string_slice("${scheme}" 0 -2)
      ans(scheme)
    endif()

    # scheme specic part is rest of uri
    set(scheme_specific_part "${str}")


    # net_path
    string_take_regex(str "${net_root_regex}")
    ans(net_path)

    # authority
    set(authority)
    if(net_path)
      string_take_regex(str "${authority_regex}")
      ans(authority)
    endif()

    string_take_regex(str "${path_char_regex}+")
    ans(path)

    string_take_regex(str "${query_regex}")
    ans(query)
    if(query)
      string_slice("${query}" 1 -1)
      ans(query)
    endif()



    if(net_path)
      set(net_path "${authority}${path}")
    endif()

    string_take_regex(str "${fragment_regex}")
    ans(fragment)
    if(fragment)
      string_slice("${fragment}" 1 -1)
      ans(fragment)
    endif()


    map_capture(${res}
      
      scheme 
      scheme_specific_part
      net_path
      authority 
      path      
      query 
      fragment 

      ${notnull}
    )

  

    # extended parse
    uri_parse_scheme(${res})
    uri_parse_authority(${res})
    uri_parse_path(${res})
    uri_parse_file(${res})
    uri_parse_query(${res})      



    return_ref(res)

  endfunction()