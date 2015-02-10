function(test)


bitbucket_repositories("kkkkkkkkkkkkkkkkkkk")
ans(res)
assert(NOT res)

  bitbucket_repositories("toeb")
  ans(res)
  assert(${res} CONTAINS test_repo_hg)
  assert(${res} CONTAINS test_repo_git)
endfunction()