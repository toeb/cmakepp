## resolve_package(<~uri>) -> <package handle>
## 
function(resolve_package)
  default_package_source()
  ans(source)
  call(source.resolve(${ARGN}))
  return_ans()
endfunction()

