
## 
## 
## invokes a package descriptors hook in the correct context
## the pwd is set to content_dir and the var args are passed along
## the result of the hook or nothing is returned
## 
## the scope of the function inherits package_handle and package_descriptor
function(package_handle_invoke_hook package_handle path)
  assign(package_descriptor = package_handle.package_descriptor)
  assign(content_dir = package_handle.content_dir)
  assign(hook = "package_descriptor.${path}")
  if(NOT "${hook}_" STREQUAL "_")
    pushd(--force)
    if(EXISTS "${content_dir}")
      cd("${content_dir}")
    endif()
      call("${hook}"(${ARGN}))
      ans(res)
    popd(--force)
    return_ref(res)
  endif()
  return()
endfunction()