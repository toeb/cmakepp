




# returns a filename which does not exist yet
# you need to pass a filter which contains the stirng {id}
# id will be varied untikl a file is found which does not exist
# the complete path will be returned
function(file_temp_name template)
  cmakepp_config(temp_dir)
  ans(temp_dir)
  file_random( "${temp_dir}/${template}")
  ans(rnd)
  return_ref(rnd)
endfunction()