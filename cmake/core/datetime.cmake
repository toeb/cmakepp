

# queries the system for the current datetime
# returns a map containing all elements of the current date
# {yyyy: <>, MM:<>, dd:<>, hh:<>, mm:<>, ss:<>, ms:<>}
function(datetime)
  shell_get()
  ans(shell)
  map_new()
  ans(dt)
  if("${shell}" STREQUAL cmd)
    shell_env_get("time")
    ans(time)
    shell_env_get("date")
    ans(date)
    
    string(REGEX REPLACE "([0-9][0-9])\\.([0-9][0-9])\\.([0-9][0-9][0-9][0-9]).*" "\\1;\\2;\\3" date "${date}")
    list_extract(date dd MM yyyy)
    

    string(REGEX REPLACE "([0-9][0-9]):([0-9][0-9]):([0-9][0-9]),([0-9][0-9]).*" "\\1;\\2;\\3;\\4" time "${time}")
    list_extract(time hh mm ss ms)

    map_capture(${dt} yyyy MM dd hh mm ss ms)

    return("${dt}")
  else()

    message(WARNING "oocmake's datetime is not implemented  for your system")
    set(yyyy)
    set(MM)
    set(dd)
    set(hh)
    set(mm)
    set(ss)
    set(ms)
    
    map_capture(${dt} yyyy MM dd hh mm ss ms)

    return("${dt}")

  endif()
endfunction()