
#to be called inside package expects ${package_dir}, ${namespace} to be set
# exports a function to a specified namespace
# usage export(foo [as bar]|[bar])
# exports function foo into ${namespace} as ${namespace}bar
function(export_function)
  set(function_path ${ARGV0})
  get_filename_component(function_name "${function_path}" NAME_WE)
  message("${function_name}")
  set(target_name ${ARGV0})
  if(${ARGC} LESS 1)
    message(FATAL_ERROR "expected at least one argument containing the function name to be exported")
    return()
  elseif(${ARGC} LESS 2) 
    #ok
  elseif(${ARGC} LESS 3)
    set(target_name ${ARGV1})
  elseif(${ARGC} LESS 4)
    set(target_name ${ARGV2})
  endif()
  
  if(NOT "${namespace}" STREQUAL "")
    set(prefix "${namespace}_")
  endif()

 # message(STATUS "${package_dir}/${function_name} as ${prefix}${function_name}")
  import_function("${package_dir}${function_path}" as "${prefix}${target_name}")
endfunction()