function(test)


  pushd(localrepo --create)
    git(init)
    fwrite("README.md" "hello")
    git(add .)
    git(commit -m "hellothere")
    git(checkout -b devel_branch)
    fwrite("README2.md" "hello")
    git(add .)
    git(commit -m "update")
    git(checkout master)
  popd()


  package_source_query_git("https://github.com/toeb/cmakepp.git" --package-handle)
  ans(res)
  assert(res)
  assertf({res.uri} MATCHES "^https:\\/\\/github.com\\/toeb\\/cmakepp.git")
  assertf({res.scm_descriptor.scm} STREQUAL "git")
  assertf({res.scm_descriptor.ref.type} STREQUAL "HEAD")
  assertf({res.scm_descriptor.ref.revision} MATCHES "[0-9A-Fa-f]+")
  assertf({res.scm_descriptor.ref.uri} STREQUAL "https://github.com/toeb/cmakepp.git")

  package_source_query_git("https://github.com/toeb/cmakepp.git?rev=b087891bd8011b2b87689e84b578561dd2e151ad" --package-handle)
  ans(res)
  assertf({res.scm_descriptor.ref.revision} STREQUAL b087891bd8011b2b87689e84b578561dd2e151ad)
  assertf({res.scm_descriptor.ref.uri} STREQUAL "https://github.com/toeb/cmakepp.git")


    ## these tests only work if ssh is configured
    # package_source_query_git("git@github.com:toeb/cmakepp.git?ref=*")
    # ans(res)
    # list(LENGTH res len)
    # assert(${len} GREATER 1)

    # package_source_query_git("git@github.com:toeb/cmakepp.git?ref=master")
    # ans(res)
    # assert(res) 
 
  package_source_query_git("https://github.com/toeb/cmakepp.git?rev=704d9d33892dd6cf9b545ce9b05fc04c113b73a7")
  ans(res)
  assert("${res}" STREQUAL "https://github.com/toeb/cmakepp.git?rev=704d9d33892dd6cf9b545ce9b05fc04c113b73a7")

  package_source_query_git("https://github.com/toeb/cmakepp.git?ref=*")
  ans(res)
  list(LENGTH res len)
  assert(${len} GREATER 1)

  package_source_query_git("https://github.com/toeb/cmakepp.git?ref=master")
  ans(res)
  assert(res) 
  assert("${res}" MATCHES "^https:\\/\\/github.com\\/toeb\\/cmakepp\\.git\\?rev=")

  package_source_query_git("test/dir")
  ans(res)
  assert(NOT res)

  package_source_query_git("https://github.com/toeb/cmakepp")
  ans(res)
  assert(res)
  
  package_source_query_git("https://github.com/toeb/cutil.git")
  ans(res)
  assert(res)

  package_source_query_git("https://github.com/toeb/cmakepp")
  ans(res)
  assert(res)


  package_source_query_git("git://github.com/toeb/cmakepp")
  ans(res)
  assert(res)


  package_source_query_git("ssh://git@github.com:toeb/cmakepp") # illegal because leading ssh:
  ans(res)
  assert(NOT res)

  package_source_query_git("//test/dir")
  ans(res)
  assert(NOT res)

  package_source_query_git("file:///test/dir")
  ans(res)
  assert(NOT res)


  package_source_query_git("localrepo")
  ans(res)
  assert(res)
  assert("${res}" MATCHES "^file:\\/\\/\\/.*localrepo\\?rev=")


endfunction()