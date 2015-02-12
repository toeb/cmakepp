  ## project_new() -> <project package>
  ## creates a new project package
  ## 
  ## a <project package> is bound to a directory and manages installed
  ## packages
  ## 
  ## it has a remote package source which is queried to install packages
  ## and a local managed package source (local) which manages
  ## installed packages
  ##
  function(project_new)
    default_package_source()
    ans(default_source)
    obj("{
      load:'project_load',
      save:'project_save',
      install:'project_install',
      uninstall:'project_uninstall',
      remote:$default_source,
      config_dir: '.cps',
      dependency_dir: 'packages'
    }")
    ans(project)
    return_ref(project)
  endfunction()