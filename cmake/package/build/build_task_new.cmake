function(build_task_new name command_template parameters)
  map_new()
  ans(build_task)

  map_set(${build_task} name "${name}")
  map_set(${build_task} commands "${command_template}")
  map_set(${build_task} parameters "${parameters}")   
  return("${build_task}") 
endfunction()
