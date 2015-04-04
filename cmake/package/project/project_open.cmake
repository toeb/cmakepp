## `(<content_dir> [<~project handle>])-><project handle>` 
##
## opens the specified project by setting default values for the existing or new project handle and setting its content_dir property to the fully qualified path specified.
## if no project handle was given a new one is created.
## if the state of the project handle is `unknown` it was never opened before. It is first transitioned to `closed` after emitting the `project_on_new` event.
## then the project handle is transitioned from `closed` to `open` first the `project_on_opening` event is emitted followed by `project_on_open`.  Afterwards the state is changed to `open` and then the `project_on_opened` event us emitted.  
## returns the project handle of the project on success. fails if the project handle is in a state other than `unknown` or `closed`. 
## 
## *note* that the default project does not contain a package source. it will have to be configured once manually for every new project
##
##
## **events**
##  * `project_on_new(<project handle>)`
##  * `project_on_opening(<project handle>)`
##  * `project_on_open(<project handle>)`
##  * `project_on_opened(<project handle>)`
##  * `project_on_state_enter(<project handle>)`
##  * `project_on_state_leave(<project handle>)`
##  * extensions also emit events.
##
## **assumes** 
## * `project_handle.project_descriptor.state` is either `unknown`(null) or `closed`
## 
## **ensures**
## * `content_dir` is set to the absolute path of the project
## * `project_descriptor.state` is set to `open`
function(project_open content_dir)
  set(args ${ARGN})

  ## try to parse args as structured data
  obj("${args}")
  ans(project_handle)

  ## fill out default necessary values
  project_handle_default()
  ans(project_handle_defaults)
  map_defaults("${project_handle}" "${project_handle_defaults}")
  ans(project_handle)

  ## set content dir
  path_qualify(content_dir)
  map_set(${project_handle} content_dir "${content_dir}")


  ## setup scope
  set(project_dir "${content_dir}")
  

  ## emit events


  ## if project is new emit that event
  project_state_matches("${project_handle}" "^(unknown)$")
  ans(is_new)
  if(is_new)
    event_emit(project_on_new ${project_handle})
    project_state_change("${project_handle}" closed)
  endif()

  
  ## open starting
  event_emit(project_on_opening ${project_handle})
  
  ## open
  event_emit(project_on_open ${project_handle})
  project_state_change("${project_handle}" opened)

  project_state_assert("${project_handle}" "^(opened)$")
  ## open complete
  event_emit(project_on_opened ${project_handle})

  return_ref(project_handle)
endfunction()