function(test)



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


  package_source_pull_git("https://github.com/toeb/cmakepp.git?rev=b087891bd8011b2b87689e84b578561dd2e151ad" "pull_dir_1")
  ans(res)
  assert(EXISTS "${test_dir}/pull_dir_1")
  assert(EXISTS "${test_dir}/pull_dir_1/package.cmake")
  assert(res)



  package_source_resolve_git("https://github.com/toeb/cmakepp.git")
  ans(res)
  assert(res)
  assertf(NOT "{res.package_descriptor}_" STREQUAL "_")
  assertf({res.package_descriptor.id} STREQUAL cmakepp)
  assertf({res.package_descriptor.license} STREQUAL MIT)



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


  # does not work with ssh/https mixture of submodule
  #package_source_pull_git("ssh://git@github.com/toeb/cutil" "clone5")
  #ans(res)
  #assert(res)
  #assert(EXISTS "${test_dir}/clone5/README.md")

  if(false)
    ## these tests only work if ssh is configured
    package_source_query_git("git@github.com:toeb/cmakepp.git?ref=*")
    ans(res)
    list(LENGTH res len)
    assert(${len} GREATER 1)

    package_source_query_git("git@github.com:toeb/cmakepp.git?ref=master")
    ans(res)
    assert(res) 
  endif()
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


  package_source_resolve_git("localrepo")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "localrepo")
  assertf({res.package_descriptor.version} STREQUAL "0.0.0")
  assertf({res.scm_descriptor.ref.type} STREQUAL "HEAD")
  assertf({res.scm_descriptor.scm} STREQUAL "git")

  package_source_pull_git("https://github.com/toeb/cmakepp" "clone3")
  ans(res)
  assert(res)
  assertf("{res.package_descriptor.license}" STREQUAL "MIT")
  assert(EXISTS "${test_dir}/clone3/README.md")


  package_source_pull_git("localrepo" "localclone1")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/localclone1/README.md")
  assert(NOT EXISTS "${test_dir}/localclone1/README2.md")

  package_source_pull_git("localrepo?branch=devel_branch" "localclone2")
  ans(res)
  assert(res)
  assert(EXISTS "${test_dir}/localclone2/README.md")
  assert(EXISTS "${test_dir}/localclone2/README2.md")



endfunction()