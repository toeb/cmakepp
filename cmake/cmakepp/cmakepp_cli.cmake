
function(cmakepp_cli)
  ## get command line args and remove executable -P and script file
  commandline_args_get(--no-script)
  ans(args)

  ## get format
  list_extract_flag(args --json)
  ans(json)
  list_extract_flag(args --qm)
  ans(qm)
  list_extract_flag(args --table)
  ans(table)
  list_extract_flag(args --csv)
  ans(csv)
  list_extract_flag(args --xml)
  ans(xml)
  list_extract_flag(args --string)
  ans(string)
  list_extract_flag(args --ini)
  ans(ini)

  string_combine(" " ${args})
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
  elseif(ini)
    ini_serialize("${result}")
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


