
  ## 
  ## 
  ## hooks:
  ##   package_descriptor.cmakepp.hooks.on_install(<project handle> <packag handle>)
  ##     this hook is invoked if it exists. it is invoked before the on_load hook 
  ##     this means that the project's exports were not loaded when the hook is called
  ##     however since cmake files are callable you can specify a local path
  function(cmakepp_project_on_package_install project_handle package_handle)
    package_handle_invoke_hook("${package_handle}" cmakepp.hooks.on_install ${project_handle} ${package_handle})
  endfunction()