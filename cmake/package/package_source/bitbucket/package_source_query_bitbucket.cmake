
## `(<~uri> [--package-handle])->`
## 
##
## 
  parameter_definition(package_source_query_bitbucket
    <--uri:<uri>>
    [--package-handle=>return_package_handle]
  )
function(package_source_query_bitbucket uri)
  arguments_extract_defined_values(0 ${ARGC} package_source_query_bitbucket)    
  ans(args)

  #list_extract_flag(args --package-handle)
  #ans(return_package_handle)


  uri_check_scheme(${uri} "bitbucket?")
  ans(scheme_ok)
  if(NOT scheme_ok)
    error("scheme {uri.scheme} is not supported - only bitbucket: or empty scheme allowed")
    return()
  endif()


  assign(segments = uri.normalized_segments)
  list_extract(segments user repo ref_type ref)
  assign(hash = uri.params.hash)

  if(NOT repo)
    set(repo *)
  endif()
  set(default false)
  if(NOT ref AND NOT ref_type)
    set(default true)
  endif()
  if(NOT ref AND NOT "${ref_type}" MATCHES "^(branches)|(tags)$")
    set(ref "${ref_type}")
    set(ref_type *)
  endif()
  if(NOT ref)
    set(ref "*")
  endif()


  map_new()
  ans(package_handles)

  if(hash)
    bitbucket_remote_ref("${user}" "${repo}" "commits" "${hash}")
    ans(remote_ref)

    map_import_properties(${remote_ref} ref_type ref)
    map_set(${package_handles} "bitbucket:${user}/${repo}/${name}/${ref_type}/${ref}" "${remote_ref}")
  elseif(user)
    if("${repo}" STREQUAL "*")
      ## get all repositories of user - no hash
      bitbucket_repositories("${user}")
      ans(names)

      foreach(name ${names})
        map_set(${package_handles} "bitbucket:${user}/${name}")
      endforeach()
    else()
      if(default)
        bitbucket_default_branch("${user}" "${repo}")
        ans(default_branch)
        if(default_branch)
          bitbucket_remote_ref("${user}" "${repo}" "branches" "${default_branch}")
          ans(ref)
          if(ref)
            map_tryget("${ref}" commit)
            ans(hash)
            set(package_uri "bitbucket:${user}/${repo}/branches/${default_branch}?hash=${hash}")
            map_set(${package_handles} "${package_uri}" ${ref})
          endif()
        endif()
      else()
        ## get all refs of the specified ref_type(s)
        bitbucket_remote_refs("${user}" "${repo}" "${ref_type}" "${ref}")
        ans(refs)

        foreach(ref ${refs})
          map_tryget(${ref} commit)
          ans(commit)
          map_tryget(${ref} ref_type)
          ans(ref_type)
          map_tryget(${ref} ref)
          ans(ref_name)

          map_set(${package_handles} "bitbucket:${user}/${repo}/${ref_type}/${ref_name}?hash=${commit}" ${ref})

        endforeach()

      else()

      endif()
    endif()
  else()
    error("you need to at least specify a bitbucket user")
    return()
  endif()


  ## create package handles if necessary

  map_keys(${package_handles})
  ans(keys)
  if(return_package_handle)
    set(map ${package_handles})
    set(package_handles)
    foreach(key ${keys})
      map_tryget(${map} ${key})
      ans(ref)
      set(package_handle)
      
      assign(!package_handle.uri = key)
      assign(!package_handle.query_uri = uri.uri)
      assign(!package_handle.bitbucket_descriptor.remote_ref = ref)
      list(APPEND package_handles ${package_handle})
    endforeach()

  else()
    set(package_handles ${keys})
  endif()
  return_ref(package_handles)
endfunction()
