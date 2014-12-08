## shorthand to fork a cmake script
function(process_fork_script scriptish)
  file_temp_name("{{id}}.cmake")        
  ans(ppath)
  fwrite("${ppath}" "${scriptish}")
  process_fork("
    {
      command: $CMAKE_COMMAND,
      args:['-P',$ppath]
    }
  ")
  return_ans()
endfunction()