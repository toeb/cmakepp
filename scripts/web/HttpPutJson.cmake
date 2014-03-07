
function(HttpPutJson response url obj)
	json_serialize(json "${obj}")
	HttpPut(res "${url}" "${json}" ${ARGN})
	set(${response} ${res} PARENT_SCOPE)
endfunction()