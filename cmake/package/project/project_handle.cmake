
## `(...)-><project handle>` 
##
## returns a project handle for the different input data
function(project_handle)

  project_constants()
  pushd()
  set(args ${ARGN})
  set(project_handle)


    ## if args are a project handle
    ## use them and set content_dir to current dir
    ref_isvalid("${args}")
    ans(is_ref)
    if(is_ref)
      set(project_handle ${args})
      pwd()
      ans(content_dir)
    else()
      ## the following section loads the project handle if it 
      ## exists in default locations
      ## afterwards the content_dir is set correctly
      path("${args}")
      ans(project_file)
      if(EXISTS "${project_file}")
        if(EXISTS "${project_file}/${project_constants_project_file}")
          set(project_file "${project_file}/${project_constants_project_file}")
        endif()

        fread_data("${project_file}")
        ans(project_handle)
          
        if(project_handle)
          ## derive content dir from configured relative project file path
          assign(project_file_path = project_handle.project_descriptor.project_file)
          string_regex_escape("${project_file_path}")
          ans(project_file_path)
          string(REGEX REPLACE "(.*)\\/${project_file_path}$" "\\1" content_dir "${project_file}")

        else()
          path("")
          ans(content_dir)
        endif()
      else()
        path("")
        ans(content_dir)
      endif()
    endif()
    ## fill out default necessary values
    project_handle_default()
    ans(project_handle_defaults)
    map_defaults("${project_handle}" "${project_handle_defaults}")
    ans(project_handle)
    ## content_dir is always set so the project stays portable
    map_set(${project_handle} content_dir ${content_dir})
    
  popd()

  return_ref(project_handle)
endfunction()