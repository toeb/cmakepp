
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034
# eval will not modify ans (the code evaluated may modify ans)
# variabls starting with __eval should not be used in code
function(eval code)
  # variables which come before incldue() are obfuscated names so that
  # they do not clutter the scope
  
  # retrieve current ans value  
  ans(__eval_current_ans)
  
  oocmake_config(temp_dir)
  ans(__eval_temp_dir)

  file_random( "${__eval_temp_dir}/eval_{{id}}.cmake")
  ans(__eval_file_name)


  file(WRITE ${__eval_file_name} "${code}")


  # restore current ans value and execute code
  set_ans("${__eval_current_ans}")
  include(${__eval_file_name})
  ans(res)

  oocmake_config(keep_temp)
  ans(keep_temp)
  if(NOT keep_temp)
    file(REMOVE ${__eval_file_name})
  endif()

  return_ref(res)
endfunction()

