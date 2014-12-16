
function(linux_ps_info pid key)
  linux_ps(-p "${pid}" -o "${key}=" --result)
  ans(res)

  map_tryget(${res} return_code)
  ans(return_code)
  if(NOT "${return_code}" EQUAL 0)

    return()
  endif()
  map_tryget(${res} output)
  ans(stdout)

  string(STRIP "${stdout}" val)
  return_ref(val)
endfunction()