## shorthand to fork a cmake script
function(process_start_script scriptish)
  file_temp_name("{{id}}.cmake")        
  ans(ppath)
  fwrite("${ppath}" "${scriptish}")
  execute(
    COMMAND
    "${CMAKE_COMMAND}"
    -P
    "${ppath}"
    ${ARGN}
    --async
  )
  return_ans()
endfunction()