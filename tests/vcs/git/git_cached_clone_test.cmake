function(test)

  return()
    function(git_cached_clone target_dir remote_uri git_ref)
     # print_vars(target_dir uri git_ref)
        set(args ${ARGN})

        list_extract_flag(args --refresh)
        ans(refresh)
        list_extract_flag(args --readonly)
        ans(readonly)

        oocmake_config(temp_dir)
        ans(temp_dir)

        string(MD5 cache_key "${remote_uri}")
        set(cached_path "${temp_dir}/git_cache/${cache_key}")


        if(EXISTS "${cached_path}" AND NOT refresh)

        endif()

        git(clone "${remote_uri}" "${target_dir}")



        return()
        pushd("${target_dir}" --create)
        ans(target_dir)


          git(clone "${remote_uri}" "${target_dir}")

          if(NOT git_ref STREQUAL "")
            git(fetch)
            git(checkout "${git_ref}")
            git(pull)
          endif()

          git(submodule init)
          git(submodule update)

        popd()
        return_ref(target_dir)
    endfunction()

    timer_start(timer1)
    git_cached_clone("dir1" "https://github.com/toeb/cmakepp" "" --refresh)
    timer_print_elapsed(timer1)

    timer_start(timer2)
    git_cached_clone("dir2" "https://github.com/toeb/cmakepp" "")
    timer_print_elapsed(timer2)






endfunction()