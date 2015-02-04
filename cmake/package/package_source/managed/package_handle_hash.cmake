  ## package_handle_hash(<~package handle>) -> <string>
  ## creates a hash for an installed package the hash should be unique enough and readable enough
  function(package_handle_hash package_handle)
    package_handle("${package_handle}")
    ans(package_handle)

    assign(id = package_handle.package_descriptor.id)
    assign(version = package_handle.package_descriptor.version)

    set(hash "${id}_${version}")
    string(REPLACE "." "_" hash "${hash}")
    string(REPLACE "/" "_" hash "${hash}")
    return_ref(hash)
  endfunction()
