
# returns the git directory for pwd or specified path
function(git_dir)
  set(path ${ARGN})
  path("${path}")
  ans(path)

  file_find_up("${path}" 0 .git)
  ans(res)
  list_peek_front(res)
  ans(res)
  return_ref(res)
endfunction()


