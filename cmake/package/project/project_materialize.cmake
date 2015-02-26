## project_materialize()
## 
## events:
##   project_on_package_install(<project package> <package handle>)
##   project_on_package_load(<project package> <package handle>)
function(project_materialize)
  set(args ${ARGN})
  list_pop_front(args)
  ans(uri)
  if(NOT uri)
    error("no uri was specified to install")
    return()
  endif()


  uri_coerce(uri)
  this_get(remote)
  this_get(local)


  ## pull package from remote source to temp directory
  ## then push it into local from there
  ## return if anything did not work

  assign(installed_package_handle = local.push("${remote}" "${uri}" => ${args}))
  
  if(NOT installed_package_handle)
    error("could not install package")
    return()
  endif()

  ## project install is executed before load
  event_emit(project_on_package_materialized "${this}" "${installed_package_handle}")

  return_ref(installed_package_handle)
endfunction()