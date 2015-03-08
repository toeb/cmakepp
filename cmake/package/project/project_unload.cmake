##
## unloads the specified project
##
## **events**
## * `project_on_unloading(<project handle>)`
## * `project_on_unloaded(<project handle>)`
function(project_unload project_handle)

  ## todo unload packages

  event_emit(project_on_unloading ${project_handle})
  event_emit(project_on_unloaded ${project_handle})
endfunction()