
function(compress_tgz target_file)
  # target_file file
  path_qualify(target_file)

  # get current working dir
  pwd()
  ans(pwd)

  # get all files to compress
  file_glob("${pwd}" ${args} --relative)
  ans(paths)

  # compress all files into target_file using paths relative to pwd()
  tar(cvzf "${target_file}" ${paths})
  return_ans()
endfunction()