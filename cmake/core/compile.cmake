
function(compile files include_dirs)
  
  function(_compile files include_dirs already_included compiled_result)
        
    foreach(file ${files})
    #  message("compiling ${file}")
      file_find("${file}" "${include_dirs}" ".cmake")
      ans(full_path)

      if(NOT full_path)
        message(FATAL_ERROR "failed to find '${file}'")
      endif()
   #   message("found at ${full_path}")
      map_tryget(${already_included}  "${full_path}")
      ans(was_compiled)

      if(NOT was_compiled)
        map_set(${already_included} "${full_path}" true)
      #  message("first encounter of ${full_path}")
        file(READ "${full_path}" content )      
       # message("content ${content}")
        string(REGEX MATCHALL "[ \t]*require\\(([^\\)]+)\\)[\r\t ]*\n" matches "${content}") 
        string(REGEX REPLACE "[ \t]*require\\(([^\\)]+)\\)[\r\t ]*\n" "\\n" content "${content}")

        set(required_files)
        foreach(match ${matches})
          string(STRIP "${match}" match)
          string(REGEX REPLACE "require\\(([^\\)]+)\\)" "\\1" match "${match}")
          list(APPEND required_files "${match}")
        endforeach()
      #  message("required_files ${required_files}")

      #  message_indent_push()
          _compile("${required_files}" "${include_dirs};${current_dir}" "${already_included}" "${compiled_result}")
       # message_indent_pop()
        ans(compiled)
      #  messagE("appending result: ${content}")
        ref_append_string(${compiled_result} "
${compiled}
## ${full_path}
${content}")


      endif()
    endforeach()

  endfunction()
  map_new()
  ans(already_included)
  ref_new()
  ans(compiled_result)
  _compile("${files}" "${include_dirs}" "${already_included}" "${compiled_result}")
  ref_get(${compiled_result} )
  ans(res)
 # message("yay ${res}")
  return_ref(res)
endfunction()