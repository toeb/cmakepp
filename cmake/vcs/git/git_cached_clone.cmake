  ## git_cached_clone(<remote uri:<~uri>> <?target_dir> [--readonly] ([--file <>]|[--read<>]) [--ref <git ref>])-> 
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
        git(clone --mirror "${remote_uri}" "${repo_cache_dir}" --exit-code)
        ans(error)
        if(error)
          rm("${repo_cache_dir}")
          message(FATAL_ERROR "git could not clone ${remote_uri}")
        endif()

      endif()
      set(result)
      pushd("${repo_cache_dir}")
        set(ref "${git_ref}")
        if(NOT ref)
          set(ref "HEAD")
        endif()
        if(read OR file)
          git(show "${ref}:${read}" --process-handle)
          ans(git_result)
          assign(error = git_result.error)
          if(NOT error)
            assign(result = git_result.stdout)
            if(file)
              set(target_path "${target_dir}/${file}")
              fwrite("${target_path}" "${result}")
              set(result "${target_path}")
            endif()
          endif()
        else()
          git(clone --reference "${repo_cache_dir}" "${remote_uri}" "${target_dir}")
          pushd("${target_dir}")
            git(checkout "${git_ref}")
            git(submodule init)
            git(submodule update)
          popd()   
          set(result "${target_dir}")
        endif()
       popd()

      return_ref(result)      

    endfunction()