## `(<project handle> <package handle>)-><path>`
##
##  creates a path which tries to be unqiue for the specified pcakge in the project
##
function(project_derive_package_content_dir project_handle package_handle)

  format("{package_handle.package_descriptor.id}")
  ans(package_id)
  string_normalize("${package_id}")
  ans(package_id)

  assign(uri = package_handle.uri)
  uri_coerce(uri)

  map_get("${uri}" scheme)
  ans(scheme)


  format("{project_handle.project_descriptor.dependency_dir}/${scheme}_{package_id}-{package_handle.package_descriptor.version}")
  ans(package_content_dir)
  return_ref(package_content_dir)
endfunction()