![cps logo](/logo.png "cps logo")

## pure cmake object oriented scripting

[![Build Status](https://travis-ci.org/toeb/oo-cmake.png?branch=devel)](https://travis-ci.org/toeb/oo-cmake)
[![Project Stats](https://www.ohloh.net/p/oo-cmake/widgets/project_thin_badge.gif)](https://www.ohloh.net/p/oo-cmake)
objects, methods, functions, maps, inheritance, parsers, lists, ...
# Installing

Download the code and include `oo-cmake.cmake` in your `CMakeLists.txt` (or other cmake script)
be sure to use an up to date version of cmake. `oo-cmake` requires cmake version `>=2.8.7`

# usage:
Look trough the files in the package.  Most functions will be commented and the other's usage can be inferred.  all functions are avaiable as soon as you include the oo-cmake.cmake file.

# Testing

To test the code (alot is tested but not all) run the following in the root dir of oo-cmake 
``` 
cmake -P oo-cmake-tests.cmake 
```

#Feature Overview

`oocmake` is a general purpose library for cmake.  It contains functionality that was missing in my opinion and also wraps some cmake functionality to fit to the style of this library.

* Features
** eval - evaluates cmake code and is the basis of many advanced features
** shell
*** readline - allows user input from the keyboard
*** directory and file functions (like bash)
**** cd(), pushd(), popd(), mkdir() pwd(), touch(), ls(), fappend(), fwrite(),...
**** path(possbilyRelativePath) -> gets the absolute path 
** debugging
*** some convinience functions
*** breakpoint() - stops execution at specified location and allows inspection of cmake variables, execution of code (if -DDEBUG_CMAKE was specified in command line)
** vcs
*** hg()... hg(init), hg(clone <url>), ...
*** git()... git(init), git(clone <url>),... shorthand for executing git in any directory
** string 
*** string_slice
*** string_splice
*** parsing and comparing semantic versions (semver)
*** ...
** lists -extension to cmake list() functionaly
*** peeking, popping, sorting, map, fold, predicates(any,all,contains,...)
** maps - basic map functions and utility functions (nested data structures for cmake)
*** get/set/append/remove operations
*** extended operations
**** nav - navigate through a path of maps, allows getting and setting e.g. nav(res = map1.prop1.prop12), nav(resultmap.prop.otherprop = res)....
**** serialization
***** json
***** quickmap format (native to cmake )
**** invert
**** import
**** capture
**** extract
**** omit
**** partial
**** pick
**** values
**** algorithms
***** depth first serach
***** breadth first search
***** graph search
***** ...
****
*** expression syntax.
**** obj("{id:1,prop:{hello:3, other:[1,2,3,4]}}") -> creates the specified object
** functions
*** define dynamic functions (without cluttering the namespace)
*** call functions dynamically (basically allowing ${functionName}(arg1 arg2 ...)
*** set a variable to the result of functions rcall(result = somefunction())
*** lambda functions (a shorthand syntax for defining inline functions. ): (var1,var2)-> do_somthing($var1); do_something_else($var2) 
*** import functions (from files, from string, ...)
** object - object oriented programming with prototypical inheritance, member functions
*** example.  (strange but valid cmake)
```
function(BaseType)
	# initialize a field
	this_set(accu 0)
	# declare a functions which adds a value to the accumulator of this object
	proto_declarefunction(accuAdd)
	function(${accuAdd} b)
		this_get(accu)
		math_eval("${accu} + ${b}")
		ans(accu)
		this_set(accu "${accu}")
		call(this.printAccu())
		return(${accu})
	endfunction()

	proto_declarefunction(printAccu)
	function(${printAccu})
		this_get(accu)
		message("value of accu: ${accu}")
	endfunction()
endfunction()
function(MyType)
	# inherit another type
	this_inherit(BaseType)
 	# create a subtract from accu function
 	proto_declarefunction(accuSub)
 	function(${accuSub} b)
 		this_get(accu)
 		math_eval("${accu} - ${b}")
		this_set(accu "${accu}")
		call(this.printAccu())
		return(${accu})
 	endfunction()

endfunction()

new(MyType)
ans(myobj)
rcall(result = myobj.add(3))
# result == 3, output 3
rcall(result = myobj.sub(2))
# result == 1, output 1
```
** other things like web queries, packing and unpacking,...



# Expressions

```
<expr> ::= <literal>|
<expr>
<function call>::= <function>(<expr>)
<string value> ::= '<cdata>'|"<cdata>"
<list> ::= <value>|<value>,<list>
<dereferenced value> ::= *<ref> 
<value> ::= <string>|<string>;<value>|<empty>
<empty> ::= <string> # length 0
<rvalue> ::= <empty>|<function call>|<string>|*<ref>|$<cmake var name>
<lvalue> ::= $<cmake var name>|*<ref>
<assignment> ::= <lvalue> = <rvalue>
<navigation> ::= <ref>.<key>|<ref>[<index>]|<var>[index]|<ref>[<key>]
<ref> ::= <cmake var name> # ${<cmake varname>} evaluates to a string: |ref:<type>:<id>
<cmake var name> ::= # a variable which evaluates to a value when ${<cmake var name>}
<indexer> ::= <expr>[<expr>]
<expr> ::= <string>|<expr><expr>|{single expr}|<var>
<single expr> ::= 	<var> = <expr> |
					<function>(<expr>) | 
					* <ref>
					<ref>.
<var> ::= <cmake var name>|<ref>|<ref path>
<ref> ::=  
<function> ::= <function cmake>|<function string>|<function string>|<function lambda>

<function cmake> := # name of function defined by cmake's function(<name>)...endfunction()
<function string> ::=  # a cmake function definition
<function file> ::= # a valid cmake file containing a <function string>
<function lambda> ::= (<args>)-><command>;<command>;... #  call return or let the last ans() be returned
```


# Returning values

**Related Functions**

* `return(...)` overwritten CMake function accepting arguments which are returned
* `ans(<var>)` a shorthand for getting the result of a function call and storing it in var
* `clr([PARENT_SCOPE])` clears the `__ans` variable in current scope or in PARENT_SCOPE if flag is set.  

A CMake function can return values by accessing it's parent scope.  Normally one does the following to return a value
```
	function(myfunc result)
		set(${result} "return value" PARENT_SCOPE)
	endfunction()
	myfunc(res)
	assert(${res} STREQUAL "return value")
```
This type of programming causes problems when nesting functions as one has to return every return value that a nested function returns. Doing this automatically would cause alot of overhead as the whole scope would have to be parsed to see which values are new after a  function call.

A cleaner alternative known from many programming languages is using a return value. I propose and have implemented the following pattern to work around the missing function return values of cmake. 

```
	function(myfunc)
		return("return_value")
	endfunction()
	myfunc()
	ans(res)
	# the __ans var is used as a register
	assert(${__ans} STREQUAL "return value")
	assert(${res} STREQUAL "return value")
```

This is possible by overwriting CMakes default return() function with a macro. It accepts variables and  will call `set(__ans ${ARGN} PARENT_SCOPE)` so after the call to `myfunc()` the scope will contain the variable `__ans`. using the `ans(<var>)` function is a shorthand for `set(<var> ${__ans})`.  

### Caveats

* The returnvalue should immediately be consumed after the call to `myfunc` because it might be reused again somewhere else.
* functions which do  not call return will not set  `__ans` in their parent scope.  If it is unclear weather a function really sets `__ans` you may want to clear it before the function call using `clr()` 
* the overwrite for `return` has to be a macro, else accessing the `PARAENT_SCOPE` would be unfeasible. However macros caus the passed arguments to be re-evaluated which destroys some string - string containing escaped variables or  other escaped characters.  This is often a problem - therfore I have als added the `return_ref` function which accepts a variable name that is then returned. 

### Alternatives
* a stack machine would also be a possiblity as this would allow returning multiple values. I have decided using the simpler single return value appoach as it is possible to return a structured list or a map if multiple return values are needed.
 
# Refs

CMake has a couple of scopes every file has its own scope, every function has its own scope and you can only have write access to your `PARENT_SCOPE`.  So I searched for  simpler way to pass data throughout all scopes.  My solution is to use CMake's `get_property` and `set_property` functions.  They allow me to store and retrieve data in the `GLOBAL` scope - which is unique per execution of CMake. It is my RAM for cmake - It is cleared after the programm shuts down.

I wrapped the get_property and set_property commands in these shorter and simple functions:

```
ref_new() 	# returns a unique refernce (you can also choose any string)
ref_set(ref [args ...]) # sets the reference to the list of arguments
ref_get(ref) # returns the data stored in <ref> 

# some more specialized functions
# which might be faster in special cases
ref_setnew([args ...]) 		# creates, returns a <ref> which is set to <args>
ref_print(<ref>)			# prints the ref
ref_isvalid(<ref>)			# returns true iff the ref is valid
ref_istype(<ref> <type>)	# returns true iff ref is type
ref_gettype(<ref>)			# returns the (if any) of the ref				
ref_delete(<ref>)			# later: frees the specified ref
ref_append(<ref> [args ...])# appends the specified args to the <ref>'s value
ref_append_string(<ref> <string>) # appends <string> to <ref>'s value
```

*Example*:
```
 # create a ref
 ref_new()
 ans(ref)
 assert(ref)
 
 # set the value of a ref
 ref_set(${ref} "hello world")

# retrieve a value by dereferencing
ref_get(${ref})
ans(val)
assert(${val} STREQUAL "hello world")

# without generating the ref:  
ref_set("my_ref_name" "hello world")
ref_get("my_ref_name")
ans(val)
assert(${val} STREQUAL "hello world")
```


# Maps

Using refs it easy to implement a map datastructure:
```
map_new()					# returns a unique reference to a map
map_get(map key)			# returns the value of map[key], fails hard if key does not exist
map_has(map key)			# returns true iff map[key] was set
map_set(map key [arg ...])	# sets map[key]
map_keys(map)				# returns all keys which were set
map_tryget(map key)			# returns the stored value or nothing: ""
map_sethidden(map key)	 	# sets a field in the map without adding the key to the keys collection
map_remove()

# specialized functions
map_append()
map_append_string()

```
 
Maps are very verstile and are missing from CMake. Due to the "variable variable" system (ie names of variables are string which can be generated from other variablees) it is very easy to implement the map system. Under the hood a value is mapped by calling `ref_set(${map}.${key})` 

## Quick Map Syntax
To quickly define a map in cmake I introduce the quick map syntax which revolves around these 4 functions and is quite intuitive to understand:
```
map([key]) # creates, returns a new map (and parent map at <key> to the new map) 
key(<key>)	# sets the current key
val([arg ...])	# sets the value at current map[current key] to <args>
end() # finishes the current map and returns it
```

*Example* 
Here is an example how to use this syntax
```
# define the map
map()
 key(firstname)
 value(Tobias)
 key(lastname)
 value(Becker)
 value(projects)
 	map()
 		key(name)
 		value(oo-cmake)
 		key(url)
 		value(https://github.org/toeb/oo-cmake)
 	end()
 	map()
 		key(name)
 		value(cutil)
 		key(url)
 		value(https://github.org/toeb/cutil)
 	end()
 end()
 map(address)
 	key(street)
 	value(Musterstrasse)
 	key(number)
 	value(99)
 end()
end()
# get the result
ans(themap)
# print the result
ref_print(${themap})
```

*Output* 
```
{
	"firstname":"Tobias",
	"lastname":"Becker",
	"projects":[
		{
			"name":"oo-cmake",
			"url":"https://github.org/toeb/oo-cmake"
		},
		{
			"name":"cutil",
			"url":"https://github.org/toeb/cutil"
		}
	]
	"address":{
		"street":"Musterstrasse",
		"number":"99"
	}
}
```

# Functions
Functions in cmake are not variables - they have a separate global only scope in which they are defined.  
*A Note on Macros* You SHOULD NOT use macros... They will more likely than not have unintended side effects because of the way the are evaluated.

I have written a couple of usefull (if not essential) functions with which managing functions becomes a lot easier
```
eval(string)			# executes the given cmake code
function_new()			# returns a unqiue name for a function
function_import(function_ish as function_name) # imports a function under the specified name
call(function_ish([args ...])) # calls a function
function_info(function_ish)	# returns info on name, arguments, type of function
function_inject(function_ish)	# imports a function, injecting before call, after call data
```

## Function Patterns

### Initializer function

If you want to execute code only once for a function (e.g. create  a datastructure before executing the function) you can use the Initializer Patter.:
```
function(initalizing_function)
	# initialization code
	function(initializing_function)
		# actual function code
	endfunction()
	initializing_function(${ARGN})
	return_ans() # forwards the returned value
endfunction()
```

*Example*
```
function(global_counter)
	ref_set(global_counter_ref 0)
	function(global_counter)
		ref_get(global_counter_ref)
		ans(count)
		math(EXPR count "${count} + 1")
		ref_set(global_counter_ref ${count})
		return(${count})
	endfunction()
endfunction()
```

# Objects 

Objects are an extension of the maps.  These are the functions which are available:
```
obj_new([Constructor]) returns a ref to a object
obj_get(obj)
obj_set(obj)
obj_has(obj)
obj_owns(obj)
obj_keys(obj)
obj_ownedkeys(obj)
obj_call(obj)
obj_callmember(obj key [args])
obj_delete(obj)
```

## Special hidden Fields
```
__type__		# contains the name of the constructor function
__proto__		# contains the prototype for this object
__getter__ 		# contains a function (obj, key)-> value 
__setter__		# contains a function (obj, key,value) 
__call__		# contains a function (obj [arg ...])
__callmember__	# contains a function (obj key [arg ..])
__not_found__ 	# gets called by the default __getter__ when a field is not found
__to_string__	# contains a function which returns a string representation for the object
__destruct__	# a function that is called when the object is destroyed
```

... more coming soon