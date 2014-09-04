
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034

function(eval code)
  # retrieve current ans value
  ans(currentans)
  oocmake_config(temp_dir)
  ans(temp_dir)

  file_random( "${temp_dir}/eval_{{id}}.cmake")
  ans(file_name)


  file(WRITE ${file_name} "${code}")


  # restore current ans value and execute code
  set_ans("${currentans}")
  include(${file_name})
  ans(res)

  oocmake_config(keep_temp)
  ans(keep_temp)
  if(NOT keep_temp)
    file(REMOVE ${file_name})
  endif()

  return_ref(res)
endfunction()

