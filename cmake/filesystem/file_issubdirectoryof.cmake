
  function(file_issubdirectoryof  subdir path)
    get_filename_component(path "${path}" REALPATH)
    get_filename_component(subdir "${subdir}" REALPATH)
    string_starts_with("${subdir}" "${path}")
    return_ans()
  endfunction()