function(test)

  message("${test_dir}")

  compile_oocmake("${oocmake_base_dir}" "${test_dir}/oocmakeall.cmake")

endfunction()