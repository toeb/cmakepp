## `(<remote uri:<~uri>> <?target_dir> [--readonly] ([--file <>]|[--read<>]) [--ref <git ref>])-> `
##
## clones the specified remote repository to the specified target directory
##
## **flags**
## `--file <repository path>`  
## `--read <repository path>`  
function(git_cached_clone remote_uri)
  set(args ${ARGN})
  

  list_extract_flag(args --readonly)
  ans(readonly)
  
  list_extract_labelled_value(args --ref)
  ans(git_ref)

  list_extract_labelled_value(args --file)
  ans(file)

  list_extract_labelled_value(args --read)
  ans(read)

  list_pop_front(args)
  ans(target_dir)


  path_qualify(target_dir)

  cmakepp_config(cache_dir)
  ans(cache_dir)

  string(MD5 cache_key "${remote_uri}" )

  set(repo_cache_dir "${cache_dir}/git_cache/${cache_key}")

  if(NOT EXISTS "${repo_cache_dir}")
    log("creating bar clone of '${remote_uri}' in cache_dir" --function git_cached_clone)
    git_lean(clone --mirror "${remote_uri}" "${repo_cache_dir}")
    ans_extract(error)
    if(error)
      rm("${repo_cache_dir}")
      throw(git_failed "git could not clone ${remote_uri}" --function git_cached_clon)
    endif()
  endif()


  set(result)
  pushd("${repo_cache_dir}")
    set(ref "${git_ref}")
    if(NOT ref)
      set(ref "HEAD")
    endif()
    if(read OR file)
      git_lean(fetch)
      ans_extract(error)
      if(error)
        throw(git_failed "failed to fetch" --function git_cached_clon)
      endif()

      log("updating cached clone of ${remote_uri}")

      git_lean(show "${ref}:${read}")
      ans_extract(error)
      ans(git_result)

      if(NOT error)
        set(result "${git_result}")
        if(file)
          set(target_path "${target_dir}/${file}")
          fwrite("${target_path}" "${git_result}")
          set(result "${target_path}")
        endif()
      endif()
    else()
      git_lean(clone --reference "${repo_cache_dir}" "${remote_uri}" "${target_dir}")
      ans_extract(error)
      if(error)
        throw(git_failed "failed to reference clone (${error}) ${__ans}" --function git_cached_clon)
      endif()
      pushd("${target_dir}")
        git_lean(checkout "${git_ref}")
        ans_extract(error)
        if(error)
          throw(git_failed "failed to checkout ${git_ref}" --function git_cached_clon)
        endif()
        git_lean(submodule init)
        ans_extract(error)
        if(error)
          throw(git_failed "failed to init submodules for  ${git_ref}" --function git_cached_clon)
        endif()
        git_lean(submodule update)
        ans_extract(error)
        if(error)
         throw(git_failed "failed to update submodules for  ${git_ref}" --function git_cached_clon)
        endif()
      popd()   
      set(result "${target_dir}")
    endif()
   popd()

  return_ref(result)      

endfunction()