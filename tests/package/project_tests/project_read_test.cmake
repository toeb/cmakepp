function(test)

  project_read()
  ans(project)
  assert(NOT project)

  fwrite("testproj.json" "")
  project_read("testproj.json")
  ans(project)
  assert(NOT project)


  fwrite("testproj.json" "{}")
  project_read(testproj.json)
  ans(project)
  assert(NOT project)


  fwrite_data("testproj.json" "{project_descriptor:{project_file:'testproj.json'}}")
  project_read(testproj.json)
  ans(project)
  assert(project)



  
  
endfunction()