
## 
## 
## hooks:
##   package_descriptor.cmakepp.hooks.on_materialized(<project handle> <packag handle>)
##     this hook is invoked if it exists. it is invoked before the on_load hook 
##     this means that the project's exports were not loaded when the hook is called
##     however since cmake files are callable you can specify a local path
function(cmakepp_project_on_package_materialized project_handle package_handle)
  package_handle_invoke_hook("${package_handle}" cmakepp.hooks.on_materialized ${project_handle} ${package_handle})
endfunction()

## register listener for the project_on_package_materialized event 
## which directly after a package is installed in a project
## this code is executed as soon as cmakepp has finisehd loading
task_enqueue("[]()event_addhandler(project_on_package_materialized cmakepp_project_on_package_materialized)")

