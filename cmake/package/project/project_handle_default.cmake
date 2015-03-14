
## `()-><project handle>`
## 
## creates the default project handle:
## ```
## {
##   uri:'project:root',
##   package_descriptor: {}
##   project_descriptor: {
##     package_cache:{}
##     package_materializations:{}
##     dependency_configuration:{}
##     dependency_dir: '${project_constants_dependency_dir}'
##     config_dir: "${project_constants_config_dir}"
##     project_file: "${project_constants_project_file}"
##     package_descriptor_file: <null>
##   }
## }
## ```
function(project_handle_default)
  project_constants()

  map_new()
  ans(package_descriptor)
  map_new()
  ans(project_descriptor)
  map_new()
  ans(package_cache)
  map_new()
  ans(package_materializations)
  map_new()
  ans(dependency_configuration)
  map_set(${project_descriptor} package_cache ${package_cache})
  map_set(${project_descriptor} package_materializations ${package_materializations})
  map_set(${project_descriptor} dependency_configuration ${dependency_configuration})
  map_set(${project_descriptor} dependency_dir "${project_constants_dependency_dir}")
  map_set(${project_descriptor} config_dir "${project_constants_config_dir}")
  map_set(${project_descriptor} project_file "${project_constants_project_file}")

  map_new()
  ans(project_handle)
  map_set(${project_handle} uri "project:root")
  map_set(${project_handle} package_descriptor "${package_descriptor}")
  map_set(${project_handle} project_descriptor "${project_descriptor}")
  
  return_ref(project_handle)
endfunction()