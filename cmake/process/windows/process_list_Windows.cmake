
## platform specific implementation for process_list under windows
function(process_list_Windows)
  win32_tasklist(/V /FO CSV)
  ans(res)
  csv_deserialize(${res} --headers)
  ans(res)
  return_ref(res)      
endfunction()