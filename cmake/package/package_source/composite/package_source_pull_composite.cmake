## package_source_pull_composite(<~uri?>) -> <package handle>
##
## pulls the specified package from the best matching child sources
## returns the corresponding handle on success else nothing is returned
parameter_definition(
  package_source_pull_composite 
  <uri{"the uri"}:<uri>> 
)
function(package_source_pull_composite)
  arguments_extract_defined_values(0 ${ARGC} package_source_pull_composite)
  ans(args)
    
  ## resolve package and return if none was found
  package_source_resolve_composite("${uri}")
  ans(package_handle)

  if(NOT package_handle)
    message("could not pull package '${uri}'")
    return()
  endif()

  ## get package source and uri from handle
  ## because current uri might not be fully qualified
  map_tryget(${package_handle} package_source_name)
  ans(package_source_name)

  if(NOT package_source_name)
    error("no package source name in package handle")
  endif()

  assign(package_source = "this.children.${package_source_name}")
  if(NOT package_source)
    error("unknown package source '${package_source_name}'")
  endif()

  map_tryget(${package_handle} query_uri)
  ans(package_uri)
  if(NOT package_uri)
    map_tryget(${package_handle} uri)
    ans(package_uri)
  endif()
  
  log("delegating pull to package source '${package_source_name}'")

  ## use the package package source to pull the correct package
  ## and return the result
  assign(package_handle = package_source.pull("${package_uri}" ${args}))

  log("done pulling '${package_uri}' from '${package_source_name}'")

  return_ref(package_handle)
endfunction()


