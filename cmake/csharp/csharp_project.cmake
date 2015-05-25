function(csharp_project name)
  set(sources ${ARGN})
  message(csharp_project)
endfunction()


function(cmake_configure project_root)
  set(args ${ARGN})

  list_extract_flag(args --clean)
  ans(clean)

  pushd("${project_root}")
  ans(project_root)

  if(EXISTS "${project_root}" AND clean)
    rm(-r build)
  endif()
  
  pushd(--create build)
    cmake(.. --passthru)
    rethrow()
  popd()
  popd()
  return()
endfunction()


function(cmake_build project_root)
  message("starting build")
  pushd("${project_root}")
  ans(project_root)
  if(NOT EXISTS "${project_root}/build")
    cmake_configure("${project_root}" ${ARGN})
    rethrow()
  endif()
  pushd("build")
    cmake(--build . --passthru)
    rethrow()
  popd()
  popd() 

  return()
  endfunction()

