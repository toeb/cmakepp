# parses simple json: only arrays, objects and double quoted strings as values and only double quoted strings as keys
# little to no error notification (be sure your json is valid)
function(json_deserialize json)
	json2("${json}")
  return_ans()
endfunction()