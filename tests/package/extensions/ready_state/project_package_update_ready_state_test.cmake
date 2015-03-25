function(test)

  project_open(.)
  ans(project)

  mock_package_source("mock" 
    A B C D E F
    "A=>B" 
    "A=>E" 
    "B=>C" 
    "B=>D" 
    "C=>D" 
    )
  ans(package_source)

  assign(project.project_descriptor.package_source = package_source)

  map_new()
  ans(context)

  event_addhandler(project_on_package_ready "[](project package) format('ready: {package.uri}'); map_append(${context} messages {{__ans}})")
  event_addhandler(project_on_package_unready "[](project package) format('unready: {package.uri}'); map_append(${context} messages {{__ans}}) ")

  project_change_dependencies(${project} "A")
  ans(res)



  timer_start(t1)
  project_materialize(${project} project:root)
  project_materialize(${project} A)
  project_materialize(${project} C)
  project_materialize(${project} D)
  project_dematerialize(${project} C)
  project_materialize(${project} B)
  project_materialize(${project} C)
  project_materialize(${project} E)
  project_change_dependencies(${project} F)
  project_materialize(${project} F)

  timer_print_elapsed(t1)
  map_tryget(${context} messages)
  ans(messages)

  json_print(${messages})

  assert(${messages} EQUALS 
    "ready: mock:D"    
    "ready: mock:C"    
    "unready: mock:C"    
    "ready: mock:C"    
    "ready: mock:B"    
    "ready: mock:E"    
    "ready: mock:A"    
    "ready: project:root"    
    "unready: project:root"    
    "ready: mock:F"    
    "ready: project:root"    

    )





endfunction()