function(test)

# writes a file_map to the pwd.
# empty directories are not created
# fm is parsed according to obj()
function(file_map_write fm)


  # define callbacks for building result
  function(fmw_dir_begin)
    map_tryget(${context} current_key)
    ans(key)
    if("${map_length}" EQUAL 0)
      return()
    endif()
    if(key)
      pushd("${key}" --create)
    else()
      pushd()
    endif()
  endfunction()
  function(fmw_dir_end)
    if(NOT "${map_length}" EQUAL 0)    
      popd()
    endif()
  endfunction()
  function(fmw_path_change)
    map_set(${context} current_key "${map_element_key}")
  endfunction()

  function(fmw_file)
    map_get(${context} current_key) 
    ans(key)
    fwrite("${key}" "${node}")
  endfunction()

   map()
    kv(value              fmw_file)
    kv(map_begin          fmw_dir_begin)
    kv(map_end            fmw_dir_end)
    kv(list_begin         fmw_file)
    kv(map_element_begin  fmw_path_change)
  end()
  ans(file_map_write_cbs)
  function_import_table(${file_map_write_cbs} file_map_write_callback)

  # function definition
  function(file_map_write fm)            
    obj("${fm}")
    ans(fm)

    map_new()
    ans(context)
    dfs_callback(file_map_write_callback ${fm} ${ARGN})
    map_tryget(${context} files)
    return_ans()  
  endfunction()
  #delegate
  file_map_write(${fm} ${ARGN})
  return_ans()
endfunction()

function(file_map_read)
  path("${ARGN}")
  ans(path)
  message("path ${path}")
  
  file(GLOB_RECURSE paths RELATIVE "${path}" ${path}/**)
  #file_glob("${path}" **/** --relative)
  #ans(paths)

  message("paths ${paths}")

 # paths_to_map(${paths})


  return_ans()

endfunction()


map()
 kv(file1 content1)
 map(dir1)
  kv(file2 content2)
  kv(file3 content3)
  map(dir11)
   kv(file4 content4)
   kv(file5 content5)
   map(dir111)
  # kv(file9 content9)
   end()
  end()
end()
map(dir2)
 kv(file6 content6)
 kv(file7 content7)
 map(dir21)
  kv(file8 content8)
 end()
end()
end()
ans(fm)


pushd("test" --create)
file_map_write(${fm})
popd()



assert(EXISTS "${test_dir}/test/file1")
assert(IS_DIRECTORY "${test_dir}/test/dir1")
assert(EXISTS "${test_dir}/test/dir1/file2")
assert(EXISTS "${test_dir}/test/dir1/file3")
assert(IS_DIRECTORY "${test_dir}/test/dir1/dir11")
assert(EXISTS "${test_dir}/test/dir1/dir11/file4")
assert(EXISTS "${test_dir}/test/dir1/dir11/file5")
assert(IS_DIRECTORY "${test_dir}/test/dir2")
assert(EXISTS "${test_dir}/test/dir2/file6")
assert(EXISTS "${test_dir}/test/dir2/file7")
assert(IS_DIRECTORY "${test_dir}/test/dir2/dir21")
assert(EXISTS "${test_dir}/test/dir2/dir21/file8")

pwd()
ans(p)
message("pwd ${p}")
file_map_read(test)
ans(res)



json_print(${res})

endfunction()