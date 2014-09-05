# reads a single file from a git repository@branch using the 
# repository relative path ${path}. returns the contents of the file
function(git_read_single_file repository branch path )
  file_tempdir()
  ans(tmp_dir)
  pushd("${tmp_dir}")
  set(branch_arg)
  if(branch)
    set(branch_arg --branch "${branch}") 
  endif()

  git(clone --no-checkout ${branch_arg} --depth 1 "${repository}" "${tmp_dir}" --return-code)
  ans(success)
  if(NOT success)
    popd()
    return()
  endif()

  if(NOT branch)
    set(branch HEAD)
  endif()



  git(show --format=raw "${branch}:${path}")
  ans(result)
  nav(res = result.output)
  nav(success = result.result)

  popd()
  
  if(NOT success)
    return()
  endif()
  

  return_ref(res)
  
endfunction()