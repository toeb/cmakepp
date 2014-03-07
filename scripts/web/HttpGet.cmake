
function(HttpGet response url)
	file_make_temporary(tmp "noting")
	file(DOWNLOAD  "${url}"  "${tmp}" LOG log ${ARGN})
	ParseHttpResponse(res "${log}")
	set(${response} ${res} PARENT_SCOPE)
endfunction()