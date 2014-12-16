## shorthand to fork a cmake script
function(process_start_script scriptish)
  file_temp_name("{{id}}.cmake")        
  ans(ppath)
  fwrite("${ppath}" "${scriptish}")
  process_start(
    COMMAND
    "${CMAKE_COMMAND}"
    -P
    "${ppath}"
    ${ARGN}
  )
  return_ans()
endfunction()