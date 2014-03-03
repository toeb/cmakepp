function(test)
	
function(map_merge target)
	set(options UNION DIFFERENCE INPLACE )
  	set(oneValueArgs TARGET)
  	set(multiValueArgs)
  	set(prefix)
  	cmake_parse_arguments("${prefix}" "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
  	#_UNPARSED_ARGUMENTS
 endfunction()





   	#a value is a string or a list
   	# a map is a value
   	# a map 


#leaves a element named package in the scope
element(package)
	value(1)
	value(2)
	value(3)
	element(subelement)
		value(a)
		value(b)
		value(c)
		value(KEY k2 VALUE 1 2 3)
		element()
			value(I)
			value(II)
			value(III)
		element(END sub2)
		element(k3)
			value(KEY a I)

		element(END)
	element(END sube)
	value(4)
	value(VALUE 5)
	value(KEY k1 VALUE 1 2 3 4 5)
element(END)

assert(package)

ref_get(value ${package})
ref_get(value2 ${sube})
ref_get(value3 ${sub2})


string(REGEX MATCHALL  "(\\[([0-9][0-9]*)\\])|(\\.[a-zA-Z0-9][a-zA-Z0-9]*)" res ".abc.bsd[1][3].asd[3].ldk3123d")
message("regex res ${res}")
map_navigate(${package} res "subelement[3]")
message("asdasd ${res}")
message("element content ${value}")
message("subelement content ${value2}")
message("subelement2 content ${value3}")
assert(EQUALS ${value} 1 2 3 subelement 4 5 k1)




endfunction()