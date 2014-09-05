# checks wether the uri is a remote git repository
function(git_remote_exists uri)
  git(ls-remote "${uri}" --return-code)
  return_ans()
endfunction()