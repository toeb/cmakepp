
function(compress_tgz target_file)
  set(args ${ARGN})
  # target_file file
  path_qualify(target_file)

  # get all files to compress
  glob(${args} --relative)
  ans(paths)

  # compress all files into target_file using paths relative to pwd()
  tar(cvzf "${target_file}" ${paths})
  return_ans()
endfunction()