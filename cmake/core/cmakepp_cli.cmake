
function(cmakepp_cli)
  ## get command line args and remove executable -P and script file
  commandline_get()
  ans(commands)
  list_pop_front(commands)
  list_pop_front(commands)
  list_pop_front(commands)



  ## get format
  list_extract_flag(commands --json)
  ans(json)
  list_extract_flag(commands --qm)
  ans(qm)
  list_extract_flag(commands --table)
  ans(table)
  list_extract_flag(commands --csv)
  ans(table)
  list_extract_flag(commands --xml)
  ans(xml)
  list_extract_flag(commands --string)
  ans(string)

  string_combine(" " ${commands})
  ans(lazy_cmake_code)

  lazy_cmake("${lazy_cmake_code}")
  ans(cmake_code)

  ## execute code
  set_ans("")
  eval("${cmake_code}")
  ans(result)


  ## serialize code
   if(json)
    json_indented("${result}")
    ans(result)
   elseif(qm)
    qm_serialize("${result}")
    ans(result)
   elseif(table)
      table_serialize("${result}")
      ans(result)
    elseif(csv)
      csv_serialize("${result}")
      ans(result)
    elseif(xml)
      xml_serialize("${result}")
      ans(result)
    elseif(string)

    else()
      json_indented("${result}")
      ans(result)
   endif()



  ## print code
  echo("${result}")
endfunction()


