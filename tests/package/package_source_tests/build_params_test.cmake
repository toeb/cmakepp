function(test)
  
  cmake_host_system()
  ans(host)

  build_params()
  ans(res)

  assertf("{res.config}" STREQUAL "release") # default to release build
  assertf("{res.linkage}" STREQUAL "shared") # default to dynamic linkage
  assertf("{res.system.id}" STREQUAL "{host.id}") # default to host system (when not crosscompiling)
  assertf(NOT "{res.compilers.cxx.id}_" STREQUAL "_" )  ## compiler has id
  assertf(NOT "{res.compilers.cxx.version}_" STREQUAL "_")  ## compiler has version


endfunction()