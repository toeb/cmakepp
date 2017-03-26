##
##
## builds the specified cmake build task
## returns null on failure
## returns a `<build>` object on success
## ```
##  <build> := 
##  {
##    task: <build_task>
##    package_handle: <package_handle>
##    task_checksum: <md5>
##    binary_dir: <qpath>
##    build_dir: <qpath>
##    
##  }
function(build_task_cmake buildTask packageHandle)
  path(.)
  ans(root)

  message(INFO "build task started...")

  checksum_object("${buildTask}")
  ans(taskChecksum)

  map_import_properties(${buildTask} generator config)

  map_import_properties(${packageHandle} content_dir)
  path_qualify(content_dir)


  ## 
  if(NOT EXISTS "${content_dir}/CMakeLists.txt")
    message(FATAL_ERROR "currently only supporting cmake packages")   
  endif()

  map_new()
  ans(result)


  set(binary_dir "${root}/binaries/${taskChecksum}")
  set(build_dir "${root}/binaries/${taskChecksum}_build")

  map_set(${result} task "${buildTask}")
  map_set(${result} task_checksum "${taskChecksum}")
  map_set(${result} binary_dir "${binary_dir}")
  map_set(${result} build_dir "${build_dir}")
  map_set(${result} package_handle "${packageHandle}")

  if(EXISTS "${binary_dir}/${taskChecksum}.success")
    message(INFO "build task using existing binary at '${binary_dir}'")
    return(${result})
  endif()

  pushd("${build_dir}" --create)
    message(INFO "build task could not locate existing binary.  generating now... (in '${build_dir}')")
    cmake(-G "${generator}" "-DCMAKE_INSTALL_PREFIX=${binary_dir}" "${content_dir}" --exit-code --passthru)          
    ans(error)
    if(NOT error)
      cmake(--build . --target install --config ${config} --exit-code --passthru)     
      ans(error)
    endif()     
  popd()
  rm(-r ${build_dir})
  if(error)
    message(WARNING "...build task could not generate new binary.")
    return()
  endif()
  message(INFO "... build task built new binary.")
  touch("${binary_dir}/taskChecksum}.success")
  return("${result}")
endfunction()