## pull_package(<~uri> <?target dir>|[--reference]) -> <package handle>
##
## --reference flag causes pull to return an existing content_dir in package handle if possible
##             <null> is returned if pulling a reference is not possbile
##
## <target dir> the <unqualified path< were the package is to be pulled to
##              the default is the current directory
##
##  pull the specified package to the target location. the package handle contains
##  meta information about the package like the package uri, package_descriptor, content_dir ...
function(pull_package)
  default_package_source()
  ans(source)
  call(source.pull(${ARGN}))
  return_ans()
endfunction()
