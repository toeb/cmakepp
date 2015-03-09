function(test)

  project_open()
  ans(project)

  assign(project.project_descriptor.package_source = default_package_source())


  project_close(${project})


  project_open()
  ans(project)

  project_change_dependencies(${project} 
    "bitbucket:toeb/test_repo_hg"
    "bitbucket:toeb/test_repo_git"
    "github:toeb/cmakepp"
    "svnscm+https://github.com/toeb/cmakepp"
    "gitscm:git@github.com:toeb/cppdynamic.git"
    "https://github.com/toeb/libarchive/archive/v3.1.2.tar.gz"
   )
  ans(res)
  json_print(${res})

  project_close(${project})





  project_open()
  ans(project)


  project_materialize_dependencies(${project})
  ans(res)



endfunction()