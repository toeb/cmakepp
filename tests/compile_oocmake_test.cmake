function(test)

  message("${test_dir}")

  compile_oocmake("${cmakepp_base_dir}" "${test_dir}/oocmakeall.cmake")

endfunction()