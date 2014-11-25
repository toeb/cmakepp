
  function(cmakeJsonParser)
    oocmake_config(base_dir)
    ans(dir)
    wrap_executable(cmakeJsonParser "${dir}/src/cmakeJsonParser/cmakeJsonParser.exe")
    cmakeJsonParser(${ARGN})
    return_ans()
endfunction()
