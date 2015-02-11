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

  package_source_resolve_git("localrepo")
  ans(res)
  assertf({res.package_descriptor.id} STREQUAL "localrepo")
  assertf({res.package_descriptor.version} STREQUAL "0.0.0")
  assertf({res.scm_descriptor.ref.type} STREQUAL "HEAD")
  assertf({res.scm_descriptor.scm} STREQUAL "git")




  package_source_resolve_git("https://github.com/toeb/cmakepp.git")
  ans(res)
  assert(res)
  assertf(NOT "{res.package_descriptor}_" STREQUAL "_")
  assertf({res.package_descriptor.id} STREQUAL cmakepp)
  assertf({res.package_descriptor.license} STREQUAL MIT)


endfunction()