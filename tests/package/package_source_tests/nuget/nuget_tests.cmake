function(test)
  if(NOT WIN32)
    return()
  endif()
#nuget(help pack --passthru)

  git_package_source()
  ans(git)

  package_source_push_nuget(${git} https://github.com/leethomason/tinyxml2.git?ref=4.0.1 => .)


endfunction()