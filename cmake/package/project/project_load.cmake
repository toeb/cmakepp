## project_load(project dir <~project config?>) -> bool
##
## 
## events:
##   project_on_load(<project package>)
##   project_on_begin_load(<project package>)
##   project_on_package_load(<project package> <package handle>)
##
function(project_load)
  set(args ${ARGN})

  ## qualify project_dir
  list_pop_front(args)
  ans(project_dir)
  path_qualify(project_dir)
  assign(this.project_dir = project_dir)

  ## parse and set project config
  project_config(${args})
  ans(project_config)
  assign(this.configuration = project_config)

  event_emit(project_on_begin_load ${this} ${project_config})

  ## qualify directories relative to project dir
  map_import_properties(${project_config} 
    content_dir 
    config_dir 
    dependency_dir
    package_descriptor_file
  )

  path_qualify_from("${project_dir}" "${package_descriptor_file}")
  ans(package_descriptor_file)
  path_qualify_from("${project_dir}" "${content_dir}")
  ans(content_dir)
  path_qualify_from("${project_dir}" "${config_dir}")
  ans(config_dir)
  path_qualify_from("${project_dir}" "${dependency_dir}")
  ans(dependency_dir)


  ## set directories
  assign(this.content_dir = content_dir)
  assign(this.config_dir = config_dir)
  assign(this.dependency_dir = dependency_dir)

  ## load package descriptor
  fread_data("${package_descriptor_file}")
  ans(package_descriptor)
  assign(this.package_descriptor = package_descriptor)


  ## create package source for project
  managed_package_source("project" "${dependency_dir}")
  ans(local)
  assign(this.local = local)

  ## load all installed packages
  ## including this project
  project_load_installed_packages()  

  ## emit loaded event
  event_emit(project_on_load ${this})  
  return(true)
endfunction()

