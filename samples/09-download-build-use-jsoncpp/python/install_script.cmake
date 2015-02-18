function(__ proj package)
  set(uri "https://www.python.org/ftp/python/3.5.0/Python-3.5.0a1.tgz")
  message(STATUS "downloading python - ${uri}")
  assign(success = proj.install("${uri}"))
  message(STATUS "done")

endfunction()