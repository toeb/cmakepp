function(test)

  json_read(${cmakepp_base_dir}/recipes/tinyxml2.json)
  ans(recipe)


  map_clone_deep("${recipe}")
  ans(recipe)


  map_tryget(${recipe} uri)
  ans(uri)


  map_remove(${recipe} uri)

  map_tryget(${recipe} parameters)
  ans(parameters)

  map_remove(${recipe} parameters)

  map_permutate(${parameters})
  ans(parameters)

  list_peek_front(parameters)
  ans(param)

  

  
  map_set(${param} config release)

  json_print(${param})

  map_template_evaluate_scoped( "${param}" "${recipe}")
  ans(evaluatedRecipe)

  json_print("${evaluatedRecipe}")
  map_conditional_evaluate("${param}" ${evaluatedRecipe})
  ans(result)


  json_print(${result})





  file_anchor_require_dir(.packages)
  ans(binary_dir)



  default_package_source()
  ans(source)


  package_source_push_path(${source} "${uri}" => "${binary_dir}/source")
  ans(packageHandle)

  map_tryget(${packageHandle} content_dir)
  ans(content_dir)


  map_set(${param} "content_dir" "${content_dir}")


  map_set(${param} "build_dir" "${binary_dir}/build")

  map_set(${param} "install_dir" "${binary_dir}/stage")



  json_print(${param})





  return()


  map_tryget(${recipe} build_descriptor)
  ans(build_descriptor)




  build_task_matrix("${build_descriptor}")
  ans(tasks)

  json_print(${tasks})

return()
  pushd(${package_dir} --create)

  foreach(task ${tasks})
    build_task_configure("${task}" "${packageHandle}"
      --build-dir "${binary_dir}/build"
      --install-dir "${binary_dir}/stage/@package_descriptor.version/@config"
      )
    ans(parameters)
  json_print(${parameters})


    build_task_execute("${task}" "${parameters}")
    ans(success)

  endforeach()
  popd()











endfunction()