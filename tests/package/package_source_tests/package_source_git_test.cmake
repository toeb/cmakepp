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


  # does not work with ssh/https mixture of submodule
  #package_source_pull_git("ssh://git@github.com/toeb/cutil" "clone5")
  #ans(res)
  #assert(res)
  #assert(EXISTS "${test_dir}/clone5/README.md")


  package_source_resolve_git("localrepo")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "localrepo")
  assertf({res.package_descriptor.version} STREQUAL "0.0.0")


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



  package_source_query_git("git@github.com:toeb/cmakepp.git?ref=*")
  ans(res)
  list(LENGTH res len)
  assert(${len} GREATER 1)

  package_source_query_git("git@github.com:toeb/cmakepp.git?ref=master")
  ans(res)
  assert(res)

  package_source_query_git("test/dir")
  ans(res)
  assert(NOT res)

  package_source_query_git("https://github.com/toeb/cmakepp")
  ans(res)
  assert(res)
  
  package_source_query_git("https://github.com/toeb/cutil.git")
  ans(res)
  assert(res)

  package_source_query_git("gitscm+https://github.com/toeb/cmakepp")
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




#  assert(${res} STREQUAL "gitscm+https://")


endfunction()