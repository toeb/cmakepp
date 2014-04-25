## used for building hierarchical data structures
# example: 
# 
#element(package)
#  value(a)
#  value(b)
#  value(c)
#  element(d)
#  	value(I)
#  	value(KEY k 1 2 3)
#  	element(e)
#  		value(1)
#  	element(END)
#  	value(b)
#  element(END)
#element(END )
#
# the code creates a map and stores its reference in package
# (you can also get the ref if you specify a name after the END tag )
# you can access the map structur with map_* operators 
# expecially in map_navigate is useful with nested structures
function(element)
	set(options )
  	cmake_parse_arguments("" "END;MAP;LIST" "" "" ${ARGN})
  	# get name
  	set(name)
  	if(_UNPARSED_ARGUMENTS)

  		list(GET _UNPARSED_ARGUMENTS 0 name)

  	endif()
    if(NOT current_element)
      set(current_key PARENT_SCOPE)
    endif()
    if(current_key)
      set(_KEY ${current_key})
      set(current_key PARENT_SCOPE)
    endif()

  	# element ends remove element from stack and retruns
  	if(_END)
  		stack_pop(element_stack )
  		ans(res)
      stack_peek(element_stack )
      ans(new_current)
  		set(current_element ${new_current} PARENT_SCOPE)
  		# if element(END var) set var to current element
  		if(name)
  			
  			set(${name} ${res} PARENT_SCOPE)
  		endif()
  		return()
  	endif()

  	# else a new element is started . a element is always a ref
    if(_MAP)
      map_new()
      ans(res)
  	elseif(_LIST)
      list_new()
      ans(res)
    else()
      map_new()
      ans(res)
    endif()
    
  	# if element is a child element then set current_element in parent scope
  	if(current_element)
  		# if element is a named element set map entry for current element
  		if(name)
  			value(KEY ${name} ${res})
  			# map_set(${current_element} ${name} ${res})
  		else()
  			# else append it as a simple value
  			value(${res})
  		endif()
	else()
		#message(STATUS "starting top level element '${name}'")
  		# if no current elment is set the element must be named
  		if(NOT name)
  			# allow unnamed tl elements  		
  		else()
  			set(${name} ${res} PARENT_SCOPE)
  		endif()
  	endif()

  	# set curretn_element and pushback element_stack
	set(current_element ${res} PARENT_SCOPE)
  	stack_push(element_stack ${res})
endfunction()

