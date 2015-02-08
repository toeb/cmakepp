
  function(cmakepp)
    oocmake_config(base_dir)
    ans(base_dir)
    cmake("-P" "${base_dir}/cmakepp.cmake" ${ARGN})
    return_ans()    
  endfunction()

  