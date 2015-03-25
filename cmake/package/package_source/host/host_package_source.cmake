## `()-> <package source>`
##
## creates a host package source which provides information
## on the host system
function(host_package_source)
  map_new()
  ans(this)
  map_set(${this} source_name "host")
  map_set(${this} query package_source_query_host)
  map_set(${this} resolve package_source_resolve_host)
  map_set(${this} pull package_source_pull_host)
  map_set(${this} rate_uri package_source_rate_uri_host)
  return(${this})
endfunction()

