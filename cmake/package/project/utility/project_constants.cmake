## `()->() *package constants are set` 
##
## defines constants which are used in project management
macro(project_constants)
  if(NOT __project_constants_loaded)
    set(__project_constants_loaded true)
    set(project_constants_dependency_dir "packages")
    set(project_constants_config_dir ".cps")
    set(project_constants_project_file "${project_constants_config_dir}/project.scmake")



  endif()
endmacro()

