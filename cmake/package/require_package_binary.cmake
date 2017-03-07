# if(NOT EXISTS "${soci_path}")
#   message("getting package soci")
#   pull_package("github:soci/soci" external/soci)  
# endif()

# `(<uri> <cmake config args>...)-> <path>`
# loads and builds the specified package.  returns the path where to where the package was installed.
#  
function(require_package_binary package_uri package_path)
  path("${package_path}")
  ans(package_path)
  # message("resolving '${package_uri}'...")
  # resolve_package("${package_uri}")
  # ans(pkg)

  # if(NOT pkg)
  #   message("could not resolve '${package_uri}'")
  #   return()
  # endif()

  # map_tryget("${pkg}" package_descriptor)
  # ans(pd)
  # map_tryget("${pd}" id)
  # ans(package_id)


  # path("${package_id}")
  # ans(package_path)


  if(NOT EXISTS "${package_path}")
    pull_package("${package_uri}" "${package_path}")
  endif()

  pushd("${package_path}" --create)
  

  #pushd("${package_id}" --create)
  if(NOT EXISTS "${package_path}/build")
    mkdir("build")
    pushd("build")

    message("package is not built... building")
    cmake(.. ${ARGN} -DCMAKE_INSTALL_PREFIX=stage --passthru)
    cmake(--build . --target install --config Release --passthru)
    cmake(--build . --target install --config Debug --passthru)
 
    message("done building ${package_id}")


    popd()

  endif()


  popd()

  set(package_stage_dir "${package_path}/build/stage")
  message("result is at ${package_stage_dir}")
  return_ref(package_stage_dir)



endfunction()

function(require_package_headeronly package_uri package_path)
   path("${package_path}")
  ans(package_path)


  if(NOT EXISTS "${package_path}")
    pull_package("${package_uri}" "${package_path}")
  endif()

  pushd("${package_path}" --create)
  #...
  popd()

  set(package_stage_dir "${package_path}")
  message("result is at ${package_stage_dir}")
  return_ref(package_stage_dir)



endfunction()