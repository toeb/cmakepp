
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034

function(eval code)
  oocmake_config(temp_dir)
  ans(temp_dir)

  random_file(file_name "${temp_dir}/eval_{{id}}.cmake")
  file(WRITE ${file_name} "${code}")
  include(${file_name})
  ans(res)
  

  oocmake_config(keep_temp)
  ans(keep_temp)
  if(NOT keep_temp)
    file(REMOVE ${file_name})
  endif()

  return_ref(res)
endfunction()
