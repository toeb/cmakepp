
function(uri_to_path uri)
  uri("${uri}")
  ans(uri)

  map_tryget(${uri} segments)
  ans(segments)

  string_combine("/" ${segments})
  ans(path)

  map_tryget(${uri} abs_root)
  if(abs_root)
    set(path "/${path}")
  endif()    


  if(WIN32)
    map_tryget("${uri}" scheme)
    ans(drive)
    if(drive)
      set(path "${drive}:${path}")
    endif()
  endif()

  return_ref(path)
endfunction()
