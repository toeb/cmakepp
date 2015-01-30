
    function(git_cached_clone target_dir remote_uri git_ref)
     # print_vars(target_dir uri git_ref)
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