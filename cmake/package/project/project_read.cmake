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
function(project_read)
  project_constants()
  path("${ARGN}")
  ans(location)
  if(EXISTS "${location}" AND NOT IS_DIRECTORY "${location}")
    set(project_file "${location}")
  else()    
    file_find_anchor("${project_constants_project_file}" ${location})
    ans(project_file)
  endif()

  if(NOT project_file)
    error("no project file found for location '{location}' " --function project_read)
    return()
  endif()


  fread_data("${project_file}")
  ans(project_handle)

  if(NOT project_handle)
    error("not a valid project file '{project_file}' " --function project_read)
    return()
  endif()


  ## derive content dir from configured relative project file path
  assign(project_file_path = project_handle.project_descriptor.project_file)
  if(NOT project_file_path)
    error("project_descriptor.project_file is missing" --function project_read)
    return()
  endif()
  string_remove_ending("${project_file}" "/${project_file_path}")
  ans(content_dir)


  project_open("${content_dir}" "${project_handle}")
  ans(project_handle)



  return_ref(project_handle)
endfunction()
