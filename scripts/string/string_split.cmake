
# splits a string by regex storing the resulting list in ${result}
#todo: this should also handle strings containing 
function(string_split result string_subject split_regex)
	string(REGEX REPLACE ${split_regex} ";" res "${string_subject}")
	set(${result} ${res} PARENT_SCOPE)
endfunction()
