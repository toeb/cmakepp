## adds a package soruce to the composite package soruce
function(composite_package_source_add source)
  assign(this.children[] = source)
  return()
endfunction()