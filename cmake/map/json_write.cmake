# write the specified object reference to the specified file
  function(json_write file obj)
    path("${file}")
    ans(file)
    json_indented(${obj})
    ans(data)
    file(WRITE "${file}" "${data}")
    return()
  endfunction()