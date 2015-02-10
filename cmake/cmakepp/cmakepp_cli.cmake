
function(cmakepp_cli)
  set(args ${ARGN})
  if(NOT args)
    ## get command line args and remove executable -P and script file
    commandline_args_get(--no-script)
    ans(args)
  endif()

  list_extract_flag(args --silent)
  ans(silent)
  list_extract_labelled_value(args --select)
  ans(select)

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


  if(select)
    string(REGEX REPLACE "@([^ ]*)" "{result.\\1}" select "${select}")
    format("${select}")
    ans(result)
   # assign(result = "result${select}")
  endif()


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
  if(NOT silent)
    echo("${result}")
  endif()
  return_ref(result)
endfunction()


