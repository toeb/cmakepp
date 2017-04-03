function(test)

  build_matrix("{
    generator:{
      '@os STREQUAL Windows': [
      'cmake -DCMAKE_INSTALL_PREFIX=@install_dir @content_dir ',
      'cmake --build . --target install --config @config']

      },
    matrix:{
      config:['release','debug'], 
      generator:['Visual Studio 2015 AMD64','Visual Studio 2015'],
      os:$os_families()
    }
    }")
  ans(res)
return()


  build_task_filter(res "'@generator' STREQUAL 'Visual Studio 2015'")
  ans(filtered)


 git_package_source()
 ans(git_source)

  package_source_push_path(${git_source} "https://github.com/leethomason/tinyxml2.git?ref=4.0.1" => sources)
  package_source_pull_path(sources --reference)
  ans(ph)

  set(i 0)
  foreach(bt ${filtered})
    path(".")
    ans(pth)

    pushd("bt${i}" --create)

    build_task_execute("${bt}" "${ph}")
    math(EXPR i "${i} + 1")
    popd()
  endforeach()



endfunction()