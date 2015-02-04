
  ## parses the package descriptor from the filename
  ## a filename's version is separated by a hyphen
  function(package_descriptor_parse_filename file_name)
    string_take_regex(file_name "([^-]|(-[^0-9]))+")
    ans(default_id)
    set(rest "${file_name}")
    string_take_regex(file_name "\\-")
    string_take_regex(file_name "v")

    semver_format("${file_name}")
    ans(default_version)
    if(default_version STREQUAL "")
      set(default_version "0.0.0")
    endif()

    data("{id:$default_id, version:$default_version}")
    return_ans()
  endfunction()