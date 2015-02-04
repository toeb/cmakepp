

  function(default_package_source)
    set(sources)

    path_package_source()
    ans_append(sources)
    
    archive_package_source()
    ans_append(sources)

    webarchive_package_source()
    ans_append(sources)

    find_package(Git)
    find_package(Hg)
    find_package(Subversion)

    if(GIT_FOUND)
      github_package_source()
      ans_append(sources)
    endif()    
  
    if(GIT_FOUND AND HG_FOUND)
      bitbucket_package_source()
      ans_append(sources)
    endif()
    
    if(GIT_FOUND)
      git_package_source()
      ans_append(sources)
    endif()

    if(HG_FOUND)
      hg_package_source()
      ans_append(sources)
    endif()

    if(SUBVERSION_FOUND)
      svn_package_source()
      ans_append(sources)
    endif()

    composite_package_source("" ${sources})
    ans(default_package_source)
    map_set(global default_package_source ${default_package_source})
    function(default_package_source)
      map_get(global default_package_source)
      return_ans()
    endfunction()
    return_ans()
  endfunction()

