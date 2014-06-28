
  # splits the speicifed path into its directories and files
  # e.g. c:/dir1/dir2/file.ext -> ['c:','dir1','dir2','file.ext'] 
  function(path_split path)
    string_split("${path}" "\\/")
    ans(parts)
    return_ref(parts)
  endfunction()