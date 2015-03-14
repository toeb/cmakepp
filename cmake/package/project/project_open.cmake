## `(<package handle> | <project dir> | <project file>)-><project handle>`
## 
##  Opens a project at `<project dir>` which defaults to the current directory (see `pwd()`). 
##  If a project file is specified it is openend and the project dir is derived.  
## 
##  Checks wether the project is consistent and if not acts accordingly. Loads the project and all its dependencies
##  also loads all materialized packages which are not part of the project's dependency graph
## 
## **returns** 
## * `<project handle>` the handle to the current project (contains the `project_descriptor`) 
## 
## **events**
## * `project_on_opening(<project handle>)` emitted when the `<project handle>` exists but nothing is loaded yet
## * `project_on_open(<project handle>)` emitted  so that custom handlers can perform actions like loading, initializing, etc
## * `project_on_opened(<project handle>)` emitted after the project was checked and loaded
## * events have access to the follwowing in their scope: 
##   * `project_dir:<qualified path>` the location of this projects root directory
##   * `project_handle:<project handle>` the handle to the project 
function(project_open)
  project_handle(${ARGN})
  ans(project_handle)
  if(NOT project_handle)
    message(FATAL_ERROR "failed to open project handle")
  endif()

  ## setup scope
  map_tryget(${project_handle} content_dir)
  ans(project_dir)
  set(project_handle ${project_handle})

  ## open starting - emit events
  event_emit(project_on_opening ${project_handle})
  
  ## perform open (calls all registered events for project open)
  ##
  ## which perform other actions like loading
  event_emit(project_on_open ${project_handle})

  ## open complete
  event_emit(project_on_opened ${project_handle})

  return_ref(project_handle)
endfunction()
