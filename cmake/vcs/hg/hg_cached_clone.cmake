
    function(hg_cached_clone target_dir uri ref)
      pushd("${target_dir}" --create)
      ans(target_dir)

        hg(clone "${remote_uri}" "${target_dir}")
        hg(update)
        if(ref)
          hg(checkout "${ref}")
        endif()
      popd()
      return_ref(target_dir)
    endfunction()