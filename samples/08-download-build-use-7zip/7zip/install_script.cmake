function(__ proj package)
  assign(_7zip_uri = package.package_descriptor.dependencies.7zip)
  message(STATUS "installing boost - ${_7zip_uri}")
  assign(success = proj.install("${_7zip_uri}"))

endfunction()