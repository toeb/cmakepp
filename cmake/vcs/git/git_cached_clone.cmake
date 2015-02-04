
    function(git_cached_clone target_dir remote_uri git_ref)
      set(args ${ARGN})
      list_extract_flag(args --readonly)
      ans(readonly)

      list_extract_labelled_value(args --file)
      ans(file)

      list_extract_labelled_value(args --read)
      ans(read)


      path_qualify(target_dir)

      oocmake_config(cache_dir)
      ans(cache_dir)

      string(MD5 cache_key "${remote_uri}" )

      set(repo_cache_dir "${cache_dir}/git_cache/${cache_key}")

      if(NOT EXISTS "${repo_cache_dir}")
        git(clone --mirror "${remote_uri}" "${repo_cache_dir}" --return-code)
        ans(error)
        if(error)
          rm("${repo_cache_dir}")
          message(FATAL_ERROR "could not clone ${remote_uri}")
        endif()

      endif()


      pushd("${repo_cache_dir}")
        set(ref "${git_ref}")
        if(NOT ref)
          set(ref "HEAD")
        endif()
        if(read)
          git(show "${ref}:${read}")
          return_ans()
        endif()

        if(file)
          git(show "${ref}:${file}")
          ans(res)
          set(target_path "${target_dir}/${file}")
          fwrite("${target_path}t" "${res}")
          return(target_path)
        endif()

        git(clone --reference "${repo_cache_dir}" "${remote_uri}" "${target_dir}")
        pushd("${target_dir}")
          git(checkout "${git_ref}")
          git(submodule init)
          git(submodule update)
        popd()
      popd()

      return_ref(target_dir)      

    endfunction()