
  function(json3 jsonString)
    file_make_temporary("${jsonString}")
    ans(tmp)
    json3file("${tmp}")
    ans(res)
    rm("${tmp}")
    return_ref(res)
  endfunction()