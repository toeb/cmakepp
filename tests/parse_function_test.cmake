function(test)





    function_parse("")
    ans(res)
    assert(NOT res)

    function_parse("hello there")
    ans(res)
    assert(NOT res)

    function_parse("function(hello arg1 arg2)\nmessage(buh)\nendfunction()")
    ans(res)
    assert(res) 
    assert(DEREF "{res.source}" STREQUAL "function(hello arg1 arg2)\nmessage(buh)\nendfunction()")
    assert(DEREF "{res.code}" STREQUAL "function(hello arg1 arg2)\nmessage(buh)\nendfunction()")
    assert(DEREF "{res.name}" STREQUAL "hello")
    assert(DEREF "{res.type}" STREQUAL "function")
    assert(DEREF "{res.source_type}" STREQUAL "string")
    assert(DEREF EQUALS "{res.args}" arg1 arg2) 

    file(WRITE "${test_dir}/func1.cmake" "function(hello arg1 arg2)\nmessage(buh)\nendfunction()")
    function_parse("${test_dir}/func1.cmake")
    ans(res)
    assert(res)
    assert(DEREF "{res.source}" STREQUAL "${test_dir}/func1.cmake")
    assert(DEREF "{res.code}" STREQUAL "function(hello arg1 arg2)\nmessage(buh)\nendfunction()")
    assert(DEREF "{res.name}" STREQUAL "hello")
    assert(DEREF "{res.type}" STREQUAL "function")
    assert(DEREF "{res.source_type}" STREQUAL "file")
    assert(DEREF EQUALS "{res.args}" arg1 arg2)


    function(func1 arg1 arg2)

      message(nyh)
    endfunction()


    function_parse(func1)
    ans(res)
    assert(res)
    assert(DEREF "{res.name}" STREQUAL "func1")
    assert(DEREF "{res.source_type}" STREQUAL "cmake")

    
endfunction()