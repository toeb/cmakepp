function(test)

  return()

  function(cmakepp_increment_version)
    cmakepp_config(base_dir)
    ans(base_dir)

    pushd("${base_dir}")

    git_remote_refs("")
    ans(refs)


    set(highest 0.0.0-alpha)
    foreach(ref ${refs})
      map_tryget(${ref} type)
      ans(type)
      if("${type}" STREQUAL "tags")
        map_tryget(${ref} name)
        ans(version)
        
        semver_gt("${semver}" "${highest}")

      endif()
    endforeach()

  endfunction()




  fwrite(pkg/package.cmake "{version:'0.0.0'}" --json)


  cmakepp_increment_version()
endfunction()