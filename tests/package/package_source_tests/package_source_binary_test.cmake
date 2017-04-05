function(test)

  build_task_matrix("{
    generator:{
      '@os STREQUAL Windows': [
      'message(INFO build @package_descriptor.id @@ @package_descriptor.version in @config )',
      '>cmake -DCMAKE_INSTALL_PREFIX=@install_dir @content_dir ',
      '>cmake --build . --target install --config @config']

      },
    matrix:{
      config:['release','debug'], 
      generator:['Visual Studio 2015 AMD64','Visual Studio 2015'],
      os:$os_families()
    }
    }")
  ans(res)



  build_task_filter(res "'@generator' STREQUAL 'Visual Studio 2015'")
  ans(filtered)


 git_package_source()
 ans(git_source)

  package_source_push_path(${git_source} "file:///C:/Users/Tobiass/Documents/projects/tinyxml2?ref=4.0.1" => sources)
  package_source_pull_path(sources --reference)
  ans(ph)

  set(i 0)
  foreach(bt ${filtered})
    path(".")
    ans(pth)

    pushd("bt${i}" --create)

    build_task_parameters(${bt} ${ph}
       --install-dir "${pth}/stage/@package_descriptor.id/@package_descriptor.version/@config" 
       --verbose
      )
    ans(parameters)


    build_task_execute(${bt} ${parameters})

    math(EXPR i "${i} + 1")
    popd()
  endforeach()



endfunction()