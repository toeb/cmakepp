
  function(fwrite_data target_file)
    data(${ARGN})
    ans(data)
    json_serialize("${data}")
    ans(serialized)
    fwrite("${target_file}" "${serialized}")
    return_ref(data)
  endfunction()
