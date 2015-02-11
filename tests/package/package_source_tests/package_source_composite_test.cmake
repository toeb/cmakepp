function(test)

  directory_package_source("dir1" "ps1")
  ans(ps1)

  fwrite_data("ps1/pkg1/package.cmake" "{id:'linker',version:'0.0.0'}" --json)
  fwrite_data("ps1/pkg2/package.cmake" "{id:'compiler',version:'0.0.0'}" --json)
  fwrite_data("ps1/pkg3/package.cmake" "{id:'binder',version:'0.0.0'}" --json)

  directory_package_source("dir2" "ps2")
  ans(ps2)


  fwrite_data("ps2/pkg1/package.cmake" "{id:'wrapper',version:'0.0.0'}" --json)
  fwrite_data("ps2/pkg2/package.cmake" "{id:'starter',version:'0.0.0'}" --json)
  fwrite_data("ps2/toeb/package.cmake" "{id:'browser',version:'0.0.0'}" --json)

  github_package_source()
  ans(ps3)

  bitbucket_package_source()
  ans(ps4)


  composite_package_source("mysource" ${ps1} ${ps2} ${ps3} ${ps4})
  ans(uut)


  assign(res = uut.query("dir1:pkg3"))

endfunction()