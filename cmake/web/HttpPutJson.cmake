
function(HttpPutJson response url obj)
	json_serialize( "${obj}")
  ans(json)
	HttpPut(res "${url}" "${json}" ${ARGN})
	set(${response} ${res} PARENT_SCOPE)
endfunction()