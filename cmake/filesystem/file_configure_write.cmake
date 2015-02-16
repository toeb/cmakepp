
  # configures a file and path
  function(file_configure_write base_dir file_name content)
    if(EXISTS "${content}")
      set(source_file "${content}")
      set(temp_file false)
    else()
      file_make_temporary( "${content}")
      ans(source_file)
      set(temp_file true)
    endif()

    # configure relative file path
    map_format("${file_name}")
    ans(configured_path)

    # if file exists configure it
    if(EXISTS "${source_file}" AND NOT IS_DIRECTORY "${source_file}")
      file_configure("${source_file}" "${base_dir}/${configured_path}" "@-syntax")
    endif()

    # remove temporary file
    if(temp_file)
    #  file(REMOVE "${source_file}")
    endif()
    return("${base_dir}/${configured_path}")
  endfunction()


  