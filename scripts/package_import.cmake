


# includes a package
# usage:
# include(package_name [namespace]|[AS namespace])
# will set output variable namespace_dir to the directory of the package
# a function called namespace_xxx is created for every exported function xxx of the package
# if namespace is not set the functions are imported directly as xxx (no trailing underscore)
function(import)
  if(${ARGC} LESS 1)
    message(FATAL_ERROR "import: no package specified")
    return()
  endif()

  # extract namespace from arguments
	set(namespace "")
  if(${ARGC} LESS 2)
    #ok
  elseif(${ARGC} LESS 3)
    set(namespace "${ARGV1}")
  elseif(${ARGC} LESS 4)
    set(namespace "${ARGV2}")
  endif()

  # package name
	set(package ${ARGV0})

  # package directory for included package  
  set(package_dir "${cutil_package_dir}/${package}")
  set(package_data_dir "${cutil_package_dir}/${package}/data")
	set(package_temp_dir "${cutil_temp_dir}/${package}")

  # set output variable package dir
  if("${namespace}" STREQUAL "")
    set("${package}_package_dir" ${package_dir} PARENT_SCOPE)
  else()
    set("${namespace}_package_dir" ${package_dir} PARENT_SCOPE)
  endif()

  if(EXISTS "${package_dir}/package.cmake")

  # include guard  - allows package to only be imported once
  normalize_variable_name(uniqueId  "${package_dir}_${namespace}_ImportGuard" )
  if(DEFINED ${uniqueId})
    message("package '${package}' was already loaded into context as ${namespace}")
    return()
  endif()
  set(${uniqueId} TRUE CACHE BOOL "include guard for ${package}")
		include("${package_dir}/package.cmake")
	else()
		message(FATAL_ERROR "could not find package '${package}' in package directory")
	endif()
endfunction()

