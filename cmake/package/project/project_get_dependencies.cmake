function(test)

  function(project_dependencies_get)

    return()
  endfunction()

  project_create(--force)
  ans(this)


  project_dependencies_get()
  ans(dependencies)

  assert(NOT dependencies)






endfunction()