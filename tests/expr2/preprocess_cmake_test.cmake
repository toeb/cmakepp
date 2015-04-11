function(test)

  set(content "
    set(a 123)
    set(abc \"lala $<> muha\")
    set(c $($a))
    ")

  cmake_token_range("${content}")
  ans(range)


  cmake_token_range_filter("${range}" \${type} MATCHES "argument" )
  ans(res)



  json_print("${res}")


endfunction()