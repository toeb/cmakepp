
## `(<path>?)-><bool>`
##
## returns true if the specified path is managed by git
## this is valid for all subdiretories of a git root as well
function(is_git_dir)
  path("${ARGN}")
  ans(path)

  if(NOT IS_DIRECTORY "${path}")
    return(false)
  endif()
  pushd("${path}")
  git_lean(status)
  ans_extract(error)

  popd()

  if(error)
    return(false)
  endif()

  return(true)
endfunction()