
## project_save(<config file path?>) -> <bool>
##
## saves the current project configuration to 
## the specified config file path.  if no path 
## is given the project is saved to the default location
##
##
function(project_save)
  set(args ${ARGN})

  assign(project_dir = this.project_dir)

  list_pop_front(args)
  ans(config_file)

  if(NOT config_file)
    assign(config_file = this.configuration.config_file)
    path_qualify_from("${project_dir}" "${config_file}")
    ans(config_file)
  else()
    path_qualify(config_file)
  endif()


  project_save_installed_packages()

  ## save package descriptor
  assign(package_descriptor_file = this.configuration.package_descriptor_file)
  path_qualify_from("${project_dir}" "${package_descriptor_file}")
  ans(package_descriptor_file)
  assign(package_descriptor = this.package_descriptor)
  fwrite_data("${package_descriptor_file}" "${package_descriptor}")

  ## save project config
  assign(configuration = this.configuration)
  fwrite_data("${config_file}" "${configuration}")



  return(true)
endfunction()