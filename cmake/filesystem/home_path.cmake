
## qualifies the specified path with the home directory
function(home_path path)
  home_dir()
  ans(home)
  set(path "${home}/${path}")
  return_ref(path)
endfunction()