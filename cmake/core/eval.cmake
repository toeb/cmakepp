
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034

function(eval code)
  random_file(file_name "${cutil_temp_dir}/eval_{{id}}.cmake")
  file(WRITE ${file_name} "${code}")
  include(${file_name})
  #file(REMOVE ${file_name})
  ans(res)
  return_ref(res)
endfunction()
