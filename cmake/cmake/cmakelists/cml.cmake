## `(...)->...`
## 
## wrapper for cmakelists_cli
function(cml)
  cmakelists_cli(${ARGN})
  return_ans()
endfunction()
