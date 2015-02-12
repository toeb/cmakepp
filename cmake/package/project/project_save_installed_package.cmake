
function(project_save_installed_package)
  event_emit(project_on_installed_package_save ${this} ${installed_package_handles})
endfunction()