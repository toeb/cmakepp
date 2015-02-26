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
      materialize:'project_materialize',
      dematerialize:'project_dematerialize',
      remote:$default_source,
      config_dir: '.cps',
      dependency_dir: 'packages'
    }")
    ans(project)

    # events
    # assign(project.on_materialize = )
    # assign(project.on_dematerialize = )
    # assign(project.on_load)
    return_ref(project)
  endfunction()