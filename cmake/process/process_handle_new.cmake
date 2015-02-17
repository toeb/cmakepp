## `(<pid>)-><process handle>`
##
## returns a new process handle
## ```
## <process handle> ::= {
##   pid: <pid>  
##   state: "unknown"|"running"|"terminated"
##   stdout: <text>
##   stderr: <text>
##   exit_code: <integer>|<error string>
##   command: <executable>
##   command_args: <encoded list>
##   on_state_change: <event>[old_state, new_state](${process_handle}) 
## }
## ``` 
function(process_handle_new start_info)
  map_new()
  ans(process_handle)
  map_set(${process_handle} pid "${pid}")
  map_set(${process_handle} start_info "${start_info}")
  map_set(${process_handle} state "unknown")
  map_set(${process_handle} stdout "")
  map_set(${process_handle} stderr "")
  map_set(${process_handle} exit_code)
  assign(process_handle.on_state_change = event_new())
  assign(process_handle.on_success = event_new())
  assign(process_handle.on_error = event_new())
  return_ref(process_handle)
endfunction()
