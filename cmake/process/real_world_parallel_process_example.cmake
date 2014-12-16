function(test)
  # real world example


  ## define a function which downloads  
  ## all urls specified to the current dir
  ## returns the path for every downloaded files
  function(download_files_parallel)
    ## get current working dir
    pwd()
    ans(target_dir)

    ## process start loop 
    ## starts a new process for every url to download
    set(handles)
    foreach(url ${ARGN})
      ## start download by creating a cmake script
      process_start_script("
        include(${oocmake_base_dir}/oo-cmake.cmake) # include oocmake
        download(\"${url}\" \"${target_dir}\")
        ans(result_path)
        message(STATUS ${target_dir}/\${result_path})
        ")
      ans(handle)
      ## store process handle 
      list(APPEND handles ${handle})
    endforeach()

    ## wait for all downloads to finish
    process_wait_all(${handles})

    set(result_paths)
    foreach(handle ${handles})
      ## get process stdout
      process_stdout(${handle})
      ans(output)

      ## remove '-- ' from beginning of output which is
      ## automatically prependend by message(STATUS) 
      string(SUBSTRING "${output}" 3 -1 output)

      ## store returned file path
      list(APPEND result_paths ${output})

    endforeach()

    ## return file paths of downloaded files
    return_ref(result_paths)
  endfunction()


  ## create and goto ./download_dir
  cd("download_dir" --create)

  ## start downloading files in parallel
  download_files_parallel(
    http://www.cmake.org/files/v3.0/cmake-3.0.2.tar.gz
    http://www.cmake.org/files/v2.8/cmake-2.8.12.2.tar.gz
  )
  ans(paths)


  assert(paths)

endfunction()