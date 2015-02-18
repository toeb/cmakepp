## returns true if file eists and is a supported archive
function(archive_isvalid file)
  mime_type("${file}")
  ans(types)


  list_contains(types "application/x-gzip")
  ans(is_archive)


  return_ref(is_archive)
endfunction()