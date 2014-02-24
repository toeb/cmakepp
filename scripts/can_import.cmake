
#checks if a function can be imported
function(can_import result function_path)
  qualify_script_file(res ${function_path})
  if(res)
    set(${result} true PARENT_SCOPE)
  else()
    set(${result} false PARENT_SCOPE)
  endif()
endfunction()