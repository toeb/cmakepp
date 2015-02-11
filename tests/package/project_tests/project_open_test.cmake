function(project_open_test)



  project_open("pr1")
  ans(proj)
  assert(NOT proj)


  project_open("pr1" --force)
  ans(proj)
  assert(proj)


  


endfunction()