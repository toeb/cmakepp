## `(<project handle> <package handle>)-><void>`
##
## **automatically register to package_on_readY"
##
## generates files inside package's content_dir
## this is useful for packages which only consist of metadata
## 
## reads all keys of `package_descriptor.generate : { <<filename template:<string>>:<file content template|cmake function call> }`. 
## These keys are treated as filenames which are formatted using `format(...)` (this allows for customized filenames)
## the property value is interpreted as a template see `template_compile`. or if it exists 
## as a call to a cmake function.
## 
## **scope**
## the following variables are available in the scope for `format` and `template_compile` and calling a function
## * `project : <project handle>`
## * `package : <package handle>`
## 
## **Example**
##
function(package_file_generator project package)
  map_import_properties(${package} package_descriptor content_dir)
  map_tryget("${package_descriptor}" generate)
  ans(generate)

  if(NOT generate)
    return()
  endif()

  map_keys(${generate})
  ans(file_names)
  set(generated_files)
  regex_cmake()
  foreach(file_name ${file_names})
    
    map_tryget(${generate} ${file_name})
    ans(file_content)

    ## ensnure that all scope variables are set
    ## package 
    ## project 
    ## package_descriptor
    ## file_name


    format("${file_name}")
    ans(relative_file_name)

    path_qualify_from("${content_dir}" "${relative_file_name}") 
    ans(file_name)

    set(custom_command false)
    if("${file_content}" MATCHES "^${regex_cmake_command_invocation}")
      set(command "${${regex_cmake_command_invocation.regex_cmake_identifier}}")
      set(args "${${regex_cmake_command_invocation.arguments}}")
      if(COMMAND "${command}")
        data("${args}")
        ans(args)
        format("${args}")
        ans(args)
        call2("${command}" ${args})
        ans(file_content)
        set(custom_command true)
      endif()
    endif()


    if(NOT custom_command)
      template_run("${file_content}")
      ans(file_content)
    endif()
    log("generating file '${relative_file_name}' for '{package.uri}'" --function package_file_generator)
    fwrite("${file_name}" "${file_content}")


    list(APPEND generated_files ${file_name})

  endforeach()

  return_ref(generated_files)


endfunction()


## register package file generator as a event handler for project_on_package_ready
task_enqueue("[]() event_addhandler(project_on_package_ready package_file_generator)")
