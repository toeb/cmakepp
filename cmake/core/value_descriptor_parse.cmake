

function(value_descriptor_parse id)
  set(ismap)
  set(descriptor)
  if(${ARGC} EQUAL 1)

    # it might be a map
    map_isvalid(${ARGV1} ismap)

    if(ismap)
      message(ismap)
      set(descriptor ${ARGV1})
    endif()
  endif()

  if(NOT descriptor)
    map_create(descriptor)
  endif()
  
  # set default values
  map_navigate_set_if_missing("descriptor.labels" "${id}")
  map_navigate_set_if_missing("descriptor.displayName" "${id}")
  map_navigate_set_if_missing("descriptor.min" "0")
  map_navigate_set_if_missing("descriptor.max" "1")
  map_navigate_set_if_missing("descriptor.id" "${id}")
  map_navigate_set_if_missing("descriptor.description" "")
  map_navigate_set_if_missing("descriptor.default" "")
  if(ismap)
    return(${descriptor})
  endif()

  cmake_parse_arguments("" "REQUIRED" "DISPLAY_NAME;DESCRIPTION;MIN;MAX" "LABELS;DEFAULT" ${ARGN})

  if(_DISPLAY_NAME)
    map_navigate_set(descriptor.displayName "${_DISPLAY_NAME}")
  endif()

  if(_DESCRIPTION)
    map_navigate_set(descriptor.description "${_DESCRIPTION}")
  endif()
  #message("_MIN ${_MIN}")
  if("_${_MIN}" MATCHES "^_[0-9]+$")
    map_navigate_set(descriptor.min "${_MIN}")
  endif()


#  message("_MAX ${_MAX}")
  if("_${_MAX}" MATCHES "^_[0-9]+|\\*$")        
    map_navigate_set(descriptor.max "${_MAX}")
  endif()

  if(_LABELS)
    map_navigate_set(descriptor.labels "${_LABELS}")
  endif()

  if(_DEFAULT)
    map_navigate_set(descriptor.default "${_DEFAULT}")
  endif()

  return(${descriptor})

endfunction()