## forks a process and returns a handle which can be used to controll it.  
##
# {
#   <pid:<unique identifier>> // some sort of unique identifier which can be used to identify the processs
#   <process_start_info:<process start info>> /// the start info for the process
#   <output:<function():<string>>>
#   <status:"running"|"complete"> // indicates weather the process is complete - this is a cached result because query the process state is expensive
# }
function(process_fork)
  wrap_platform_specific_function(process_fork)
  process_fork(${ARGN})
  return_ans()
endfunction()


