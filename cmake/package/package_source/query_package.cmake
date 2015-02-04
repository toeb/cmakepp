## query_package(<~uri> [--package-handle]) -> <uri string>|<package handle>
## queries the default package source for a package
function(query_package)
  default_package_source()
  ans(source)
  call(source.query(${ARGN}))
  return_ans()
endfunction()
