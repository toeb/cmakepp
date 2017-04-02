function(test)

 # print_vars(CMAKE_SYSTEM_NAME CMAKE_SYSTEM_VERSION CMAKE_SYSTEM_PROCESSOR CMAKE_HOME_DIRECTORY CMAKE_HOST_SYSTEM_NAME CMAKE_)
cmake_environment()
ans(env)
json_print(${env})


  function(package_source_binary_push)


  endfunction()


## returns all known host systems
  function(os_families)
    return(Windows Unix OSX)
  endfunction()

  map_new()
  ans(buildConfig)


  map_set(${buildConfig} config "release;debug")
  map_set(${buildConfig} type "shared;static")


function(template_run_scoped scope)
  map_import_properties_all(${scope})
  template_run("${ARGN}")
  return_ans()
endfunction()

function(eval_predicate_cmake code)
  address_new()
  ans(__temp_address)
  eval("if(${code})\naddress_set(${__temp_address} true)\nelse()\naddress_set(${__temp_address} false)\nendif()")
  address_get(${__temp_address})
  return_ans()
endfunction()

function(eval_predicate_template_cmake scope template)
    template_run_scoped(${scope} "${template}")
    ans(expr)
    eval_predicate_cmake("${expr}")
    ans(use)        
    return_ref(use)
endfunction()

  

  # git_package_source()
  # ans(git_source)

  # package_source_push_path(${git_source} "https://github.com/leethomason/tinyxml2.git?ref=4.0.1" => sources)

  # package_source_pull_path(sources --reference)
  # ans(ph)

  function(build_matrix )
    data("${ARGN}")
    ans(config)


    os_families()
    ans(families)

    map_tryget(${config} matrix)
    ans(mat)

    map_defaults(${mat} "{os:$families}")

    if(mat)
      map_permutate(${mat})
      ans(mat)

    endif()


    
    map_tryget(${config} generator)
    ans(generator)
    is_map(${generator})
    ans(isMap)
    if(NOT isMap)
      map_new()
      ans(gen)
      map_set(${gen} true "${generator}")
      set(generator "${gen}")
    endif()

    json_print(${generator})

    while(true)
      list(LENGTH mat len)
      if("${len}" EQUAL 0)
        break()
      endif()
      list_pop_front(mat)
      ans(currentMat)



      map_keys(${generator})
      ans(genkeys)


      foreach(key ${genkeys})
        eval_predicate_template_cmake("${currentMat}" "${key}")
        ans(use)
        if(use)
          map_tryget(${generator} "${key}")
          ans(gen)
          template_run_scoped("${currentMat}" "${gen}")
          ans(evaluated_gen)
          map_set(${currentMat} __gen "${evaluated_gen}")
          print_vars(currentMat)
          break()
        endif()

      endforeach()


    endwhile()



  endfunction()

  build_matrix("{
    generator:{'@os STREQUAL Windows': ['cmake -DCMAKE_INSTALL_PREFIX=stage {target_dir}','cmake --build . --target install --config @config']},
    matrix:{
      config:['release','debug'], 
      generator:['Visual Studio 2015 AMD64','Visual Studio 2015'],
      main:['a', 'b']
    }


    }")



  #provide install_dir 
  #provide content_dir
  #provide package handle
  # {
  #     generator:
  #     {
  #       default: [
  #         "mkdir build"
  #         "cd build"
  #         "cmake -G -DCMAKE_INSTALL_PREFIX={install_dir} {target_dir}"
  #         "cmake --build . --config {config} --target install"
  #       ]
  #       win:[

  #       ],
  #       unix[

  #       ]

  #     }
  #     matrix:[
  #     {
  #         config :[debug, release] 
  #         generator: ['Visualstiode 2010','visiual studio 2015']
  #     },      
  #     {
  #         config: release
  #         generator:  sublime
  #     }
        
  # }


  ## its problematic:  sometimes i need readonly file access
  ## sometimes i need a copy of the source_group

  ## sometimes i'v got a makefile 

  ## sometimes i'v got cmake a cmake build 


  ## sometimes 


  ## how do i find out if a package is a binary?

  ## maybe i better stay in the cmake world for --no-warn-unused-cli


  json_print("${ph}")






endfunction()