
function(linux_ps_info pid key)
  linux_ps(-p "${pid}" -o "${key}=" --process-handle)
  ans(res)

  map_tryget(${res} exit_code)
  ans(erro)
  if(NOT "${erro}" EQUAL 0)

    return()
  endif()
  map_tryget(${res} stdout)
  ans(stdout)

  string(STRIP "${stdout}" val)
  return_ref(val)
endfunction()