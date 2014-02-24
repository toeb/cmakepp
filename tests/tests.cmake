macro(tests)
#
#test_register(eval_test)
#function(eval_test)
#	eval("function(eval_test_function result)  \n set(\\\${result} hello PARENT_SCOPE) \n endfunction()")
#	eval_test_function(res)
#	assert("should set result value of evaluated function" "${res}" STREQUAL hello)
#endfunction()
#
#test_register(subdirlist_test)
#
#function(subdirlist_test)
#    import(core as mycore)
#	file(MAKE_DIRECTORY "${cutil_temp_dir}/subdirlist_test/dir1")
#	file(MAKE_DIRECTORY "${cutil_temp_dir}/subdirlist_test/dir2")
#
#	mycore_subdirlist(dirs "${cutil_temp_dir}/subdirlist_test")
#
#	list(LENGTH dirs count )
#
#	assert("should return correct number of directories (2)" ${count} EQUAL 2)
#
#endfunction()
#

endmacro()