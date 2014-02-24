
function(parse_function result function_string)
   function_signature_regex(regex)
   get_function_signature(signature "${function_string}")

   string(REGEX REPLACE ${regex} "\\1" func_type "${signature}" )
   string(REGEX REPLACE ${regex} "\\2" func_name "${signature}" )
   string(REGEX REPLACE ${regex} "\\3" func_args "${signature}" )



   # get args
   string(FIND "${func_args}" ")" endOfArgsIndex)
   string(SUBSTRING "${func_args}" "0" "${endOfArgsIndex}" func_args)
   
   if(func_args)
      string(REGEX MATCHALL "[A-Za-z0-9_\\\\-]+" all_args ${func_args})
   endif()

   string(SUBSTRING "${func_args}" 0 ${endOfArgsIndex} func_args)
   string(TOLOWER "${func_type}" func_type)


   #debug_message("parsed function ${signature} : type: ${func_type}, name: ${func_name}, args: ${all_args}" )
   #debug_message("parsed function ${function_string}" )
   return_prefixed_value("type" "${func_type}")
   return_prefixed_value("name" "${func_name}")
   return_prefixed_value("args" "${all_args}")

endfunction()
