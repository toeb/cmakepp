function(test)

  message("${test_dir}")

  cmakepp_compile("${cmakepp_base_dir}" "${test_dir}/cmakepp_compile_result.cmake")

endfunction()