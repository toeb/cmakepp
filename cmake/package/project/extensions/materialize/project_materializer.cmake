
function(project_materializer project)
  ## materialize project if it is not materialized
  map_tryget(${project} materialization_descriptor)
  ans(is_materialized)
  if(NOT is_materialized)
    map_tryget(${project} uri)
    ans(project_uri)
    project_materialize(${project} "${project_uri}")
  endif()
endfunction()