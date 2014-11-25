# compresses all files specified in glob expressions (relative to pwd) into ${target} tgz file
# usage: compress(<file> [<glob> ...]) - 
# 
function(compress target)
  set(args ${ARGN})
  
  # target file
  path("${target}")
  ans(target)

  # get current working dir
  pwd()
  ans(pwd)

  # get all files to compress
  file_glob("${pwd}" ${args} --relative)
  ans(paths)

  # compress all files into target using paths relative to pwd()
  tar(cvzf "${target}" ${paths})
  return_ans()

endfunction()