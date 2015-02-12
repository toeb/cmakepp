function(project_save_installed_packages)
  assign(installed_package_handles = this.installed_package_handles)

  foreach(installed_package_handle ${installed_package_handles} ${this})
    project_save_installed_package(${installed_package_handle})
  endforeach()

  event_emit(project_on_installed_packages_save ${this})
endfunction()

