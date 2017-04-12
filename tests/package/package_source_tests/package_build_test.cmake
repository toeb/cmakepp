function(test)

  json_read(${cmakepp_base_dir}/recipes/tinyxml2.json)
  ans(recipe)


  map_tryget(${recipe} build_descriptor)
  ans(build_descriptor)


  map_tryget(${recipe} uri)
  ans(uri)


  file_anchor_require_dir(.packages)
  ans(binary_dir)

  default_package_source()
  ans(source)


  package_source_push_path(${source} "${uri}" => "${binary_dir}/source")
  ans(packageHandle)


  build_task_matrix("${build_descriptor}")
  ans(tasks)

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