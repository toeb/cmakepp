
# returns true if value could be parsed
function(list_parse_descriptor descriptor)  
  cmake_parse_arguments("" "" "UNUSED_ARGS;ERROR" "" ${ARGN})

  set(args ${_UNPARSED_ARGUMENTS})
  map_import(${descriptor})
  list_find_first(args ${labels})
  ans(starting_index)

  list_slice(args 0 ${starting_index})
  ans(unused_args)
  list_slice(args ${starting_index} -1)
  ans(value_args)
  set(cut_off ${max})

  # remove first arg as its the flag used to start this value
  list_pop_front( value_args)
ans(used_label)
  # list length
  list(LENGTH value_args len)

  if("${cut_off}" STREQUAL "*")
    set(cut_off -1)
  endif()
  
  math_min(${len} ${cut_off})
  ans(cut_off)  
  list_slice(value_args "${cut_off}" -1)
  ans(tmp)

  list(APPEND unused_args ${tmp})

  # set result value for unused args
  if(_UNUSED_ARGS)
    set(${_UNUSED_ARGS} ${unused_args} PARENT_SCOPE)
  endif()
  
  list_slice(value_args 0 "${cut_off}")
  ans(value_args)


  # option
  if(${min} STREQUAL 0 AND ${max} STREQUAL 0)
    if(starting_index LESS 0)
      return(false)
    else()
      return(true)
    endif()
  endif()


  # if less than min args are avaiable set error to true but
  # still return the found values however
  if(${cut_off} LESS ${min} )
    set(${_ERROR} true PARENT_SCOPE)
  else()
    set(${_ERROR} false PARENT_SCOPE)
  endif()


  # use return ref because value_args might return strange strings
  return_ref(value_args)

endfunction()