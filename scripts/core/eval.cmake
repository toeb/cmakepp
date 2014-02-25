
# Evaluate expression
# Suggestion from the Wiki: http://cmake.org/Wiki/CMake/Language_Syntax
# Unfortunately, no built-in stuff for this: http://public.kitware.com/Bug/view.php?id=4034
macro(eval code)
  random_file(file_name "${cutil_temp_dir}/eval_{{id}}.cmake")
  # create a temporary file to include
  # insert code to be eval'ed
  file(WRITE ${file_name} "${code}")

  #debug_message("evaluating ${file_name} : ${code}")
  
  #include code
  include(${file_name})
  
  #delete temporary file
  if(NOT cutil_keep_export AND NOT cutil_debug_eval)
    file(REMOVE ${file_name})
    else()
    #message(STATUS "eval kept at ${file_name}")
  endif()
endmacro(eval)