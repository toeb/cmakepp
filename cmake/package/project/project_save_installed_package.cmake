
function(project_save_installed_package installed_package_handle)
  event_emit(project_on_installed_package_save ${this} ${installed_package_handle})
endfunction()