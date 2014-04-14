
  function(stream_take stream length)
    ref_get(${stream} data)
    string(SUBSTRING "${data}" 0 "${length}" result)
    string(SUBSTRING "${data}" "${length}" -1 data)
    ref_set(${stream} "${data}")
    return_ref(result)
  endfunction()
