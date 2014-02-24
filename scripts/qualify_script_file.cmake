
#qualifies a filename until it exists
function(qualify_script_file output filepath)
  if(EXISTS ${filepath})
    set(${output} ${filepath} PARENT_SCOPE)
    return()
  endif()

  if(EXISTS "${filepath}.cmake")
    set(${output} "${filepath}.cmake" PARENT_SCOPE)
    return()
  endif()

  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${filepath}")
    set(${output} "${CMAKE_CURRENT_LIST_DIR}/${filepath}" PARENT_SCOPE)
    return()
  endif()


  if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${filepath}.cmake")
    set(${output} "${CMAKE_CURRENT_LIST_DIR}/${filepath}.cmake" PARENT_SCOPE)
    return()
  endif()


  if(EXISTS "${package_dir}/${filepath}.cmake")
    set(${output} "${package_dir}/${filepath}.cmake" PARENT_SCOPE)
    return()
  endif()


  if(EXISTS "${package_dir}/${filepath}")
    set(${output} "${package_dir}/${filepath}" PARENT_SCOPE)
    return()
  endif()

endfunction()