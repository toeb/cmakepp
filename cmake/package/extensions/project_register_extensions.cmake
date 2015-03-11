function(project_register_extensions)

  event_addhandler(project_on_open project_materialization_check)
  event_addhandler(project_on_open project_loader)
  event_addhandler(project_on_close project_unloader)
  
  event_addhandler(project_on_package_ready project_loader)
  event_addhandler(project_on_package_ready cmakepp_on_ready_hook)
  event_addhandler(project_on_package_ready package_dependency_symlinker)

  event_addhandler(project_on_package_dematerializing cmakepp_on_dematerializing_hook)
  event_addhandler(project_on_package_materialized cmakepp_on_materialized_hook)
  
  event_addhandler(project_on_package_loaded cmake_export_handler)
  event_addhandler(project_on_package_loaded cmakepp_on_loaded_hook)
  event_addhandler(project_on_package_loaded project_cmake_export_module)

  event_addhandler(project_on_package_unloading cmakepp_on_unloading_hook)

  event_addhandler(project_on_package_unready project_unloader)
  event_addhandler(project_on_package_unready "[]() package_dependency_symlinker({{ARGN}} --unlink)")
  event_addhandler(project_on_package_unready cmakepp_on_unready_hook)



endfunction()


## react to ready/unready events
task_enqueue(project_register_extensions)
