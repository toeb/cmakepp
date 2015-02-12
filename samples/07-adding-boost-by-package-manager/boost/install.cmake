function(__ proj package)
  assign(boost_uri = package.package_descriptor.dependencies.boost)
  message(STATUS "installing boost - ${boost_uri}")
  assign(success = proj.install("${boost_uri}"))

endfunction()