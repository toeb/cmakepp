
  # configures a map of files where the key is the configurable path and content
  # is either an existing file or  string cotnent for a file
  function(file_configure_write_map base_dir files)
    set(res)
    map_keys("${files}" )
    ans(file_names)
    foreach(file_name ${file_names})
      # get value for file. if value is a valid file use that file 
      # else use value as the content for the file
      map_get("${files}"  "${file_name}")
      ans(content)
      file_configure_write("${base_dir}" "${file_name}" "${content}")
      ans(configured_path)
      list(APPEND res "${configured_path}")
    endforeach()
    return(${res}) 
  endfunction()