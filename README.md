oo-cmake
======== 
[![Build Status](https://travis-ci.org/toeb/oo-cmake.png?branch=master)](https://travis-ci.org/toeb/oo-cmake)
objects, methods, functions, maps, inheritance, oo-cmake goodness

# Installing

Download the code and include `oo-cmake.cmake` in your `CMakeLists.txt` (or other cmake script)
be sure to use an up to date version of cmake.  `oo-cmake.cmake` adds this:

```
cmake_minimum_required(VERSION 2.8.7)
cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)
```
# Testing

To test the code (alot is tested but not all) run the following in the root dir of oo-cmake 
``` 
cmake -P oo-cmake-tests.cmake 
```

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
function_call(function_ish([args ...])) # calls a function
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
obj_new(obj [Constructor])
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


# Functions

To correctly work with object oriented programming in cmake dynamic functions are a must.
I have written some methods for handling, parsing, injecting, importing, saving, loading functions
Try the following example to get an overview of what is possible

```

## creating functions

## the plain cmake function (with input and output vars)
## =====================================================
# defining a function:
function(my_function arg)
	set(result "${arg}" PARENT_SCOPE)
endfunction()
# calling the function:
my_function("sample1")
assert(result)
assert(${result} STREQUAL "sample1")


# -> things to note about plain cmake functions:  
# -> cmake only has one global namespace for functions (no scoping like with variables)
# -> functions can be overwritten (even functions defined by cmake)
# -> functions cannot be called dynamically (ala '${dynamic_name}(args)')
# -> functions can be defined dynamically ( function(${dynamic_name} arg1 arg2) .... endfunction())

## dynamically calling a function  'call_function'
## ===============================================
set(function_name my_function)
call_function(${function_name} sample2)

assert(result)
assert(${result} STREQUAL "sample2")


## declaring, defining and calling a unique dynamic function
## =========================================================
new_function(my_unique_function)
assert(COMMAND ${my_unique_function})
message("${my_unique_function}")
# my_unique_function now contains a unique string e.g. func_nTGSmkIGHL
# it is only declared. uncommenting the following line results in a FATAL_ERROR
# call_function(${my_unique_function})
#the function still has to be defined: 
function(${my_unique_function} arg1 arg2)
	set(result "${arg2} ${arg1}" PARENT_SCOPE)
endfunction()
# call function
call_function(${my_unique_function} world hello)
assert(${result} STREQUAL "hello world")


## calling a function string
## =========================
# you can call any string that is a cmake function
# it does not matter what name the function has
# be sure to escape the string correctly
# WARNING using ; and ${ARGN} or carriage returns may lead to unexpected results 
# incorrectly escaping variables will be cause of many a bug
call_function("function(fu arg1 arg2) \n message(nuna) \nset(result \"\${arg1} \${arg1} \${arg2} \${arg2}\" PARENT_SCOPE) \n endfunction()" a b)
assert("${result}" STREQUAL "a a b b")


## calling a function file
## =======================
# you can also call any file that contains a function (the first function will be called)
# WARNING: there is still a bug that does not allow tabs before the signature and newlines in the signature (this will be fixed soon)
# create a file containing a function
file_make_temporary(file_name "function(fu arg1 arg2) \n message(nanu) \n set(result \"\${arg1} \${arg2}\" PARENT_SCOPE) \n endfunction()")
call_function(${file_name} b a )
assert(${result} STREQUAL "b a ")


## importing a function
## ====================
#any kind of function can be imported 
# the REDEFINE flag allows afunction to be overwritten (not setting it would cause an error if a function fuu already exists (2. and 3. call))
# a usefull application iterating a list of files containing unit test functions and calling each with the same name
# also when working with packages this allows functions to be defined in a specified namespace
import_function(my_function as fuu REDEFINE)
fuu(sample4)
assert(${result} STREQUAL "sample4")
import_function(${file_name} as fuu REDEFINE)
fuu(a b) 
assert(${result} STREQUAL "a b")
import_function("function(fu arg1 arg2) \n message(nuna) \nset(result \"\${arg1} \${arg1} \${arg2} \${arg2}\" PARENT_SCOPE) \n endfunction()" as fuu REDEFINE)
fuu(a b)
assert(${result} STREQUAL "a a b b")


## injecting
## =========


## parsing
## =======

```
# Object Tutorial
```
### using objects
	### =============
	# oo-cmake is very similar to javascript
	# I actually used the javascript reference to figure out how things could be done :)
	# oo-cmake is a pure object oriented language like javascript (only objects no types per se)
	# oo-cmake is currently file based and relies heavily on dynamic functions to be upfron about it:
	# oo-cmake is very slow (depending on what your doing)

	## creating a object
	## =================
	obj_new(myobject)
	# ${myobject} now is a reference to an object
	obj_exists(${myobject} _exists)
	assert(_exists)

	## deleting a object
	## =================
	# oo-cmake does not contains automatic memory management
	# you can however remove all objects by calling obj_cleanup 
	# (a very crude way of garbage collection) I would suggest calling it at the end of cmake.
	obj_new(object_to_delete)
	obj_delete(${object_to_delete})
	# object_to_delete still contains the same reference
	# but the object does not exists anymore and the following returns false
	obj_exists(${object_to_delete} _exists)
	assert(NOT _exists)


	## setting and setting property
	## ==================
	obj_new(myobject)
	# call obj_set passing the object reference
	# the propertyname 'key1' and the value 'val1'
	# everything beyond 'key1' is saved (as a list)
	obj_set(${myobject} key1 "val1")
	#call obj_get passing the object refernce the result variable and
	# the key which is to be gotten
	obj_get(${myobject} theValue key1)
	assert(theValue)
	assert(${theValue} STREQUAL "val1")


	## setting a function and calling it
	## =================================
	obj_new(obj)
	obj_set(${obj} last_name "Becker")
	obj_set(${obj} first_name "Tobias")
	#obj_setfunction accepts any function (cmake command, string function, file function, unique function (see function tutorial))
	# if you use a cmake function be sure that it will not be overwritten
	# the safest way to add a function is to use obj_declarefunction
	# you can either specify the key where it is to be stored or not
	# if you do not specify it the name of the function is used
	function(greet result)
		# in the function you have read access to all fields of the proeprty
		# as will as to 'this' which contains the reference to the object

		# this sets the variable ${result} in PARENT_SCOPE (returning values in cmake)
		set(${result} "Hello ${first_name} ${last_name}!" PARENT_SCOPE)

	endfunction()
	obj_setfunction(${obj} greet)
	obj_callmember(${obj} greet res)
	assert(res)
	assert(${res} STREQUAL "Hello Tobias Becker!")
	# alternatively you can also use obj_declarefunction
	# this is actually the easiest way to define a function in code
	obj_declarefunction(${obj} say_goodbye)
	function(${say_goodbye} result)
		set(${result} "Goodbye ${first_name} ${last_name}!" PARENT_SCOPE)
	endfunction()
	obj_callmember(${obj} say_goodbye res)
	assert(res)
	assert(res STREQUAL "Goodbye Tobias Becker!")

	## built in methods
	## ================
	# obj_new creates a object which automatically inherits Object
	# Object contains some functions e.g. to_string, print, ...
	# 
	obj_new(obj)
	obj_callmember(${obj} print)

	# this prints all members
	# ie
	#{
	# print: [function], 
	# to_string: [function], 
	# __ctor__: [object :object_Y3dVWkChKi], 
	# __proto__: [object :object_AztQwnKoE7], 
	#}


	## constructors
	## ============
	# you can easily define a object type via constructor
	function(MyObject)
		# declare a function on the prototype (which is accessible for all objects)
		# inheriting from MyObject
		obj_declarefunction(${__proto__} myMethod)
		function(${myMethod} result)
			set(${result} "myMethod: ${myValue}" PARENT_SCOPE)
			this_set(myNewProperty "this is a text ${myValue}")
		endfunction()

		# set a field for the object
		this_set(myValue "hello")
	endfunction()

	obj_new(obj MyObject)
	# type of object will now be MyObject
	obj_gettype(${obj} type)
	assert(type)
	assert(${type} STREQUAL MyObject)
	# call
	obj_callmember(${obj} myMethod res)
	assert(res)
	assert(${res} STREQUAL "myMethod: hello")
	obj_set(${obj} myValue "othervalue")
	obj_callmember(${obj} myMethod res)
	assert(res)
	assert(${res} STREQUAL "myMethod: othervalue")
	obj_get(${obj} res myNewProperty)
	assert(res)
	assert(${res} STREQUAL "this is a text othervalue")

	## functors
	## ========

	## binding a function
	## ==================
	# you can bind any function to an object without
	# setting it as property
	# causing the function to get access to 'this'
	# and all defined properties
	function(anyfunction)
		this_callmember(print)
	endfunction()
	obj_new(obj)
	obj_bindcall(${obj} anyfunction)
	## print the object
	# alternatively you can bind the function to the object
	obj_bind(boundfu ${obj} anyfunction)
	call_function(${boundfu})
	# prints the object
	# alternatively you can bind and import then function
	# beware that you might overwrite a defined function if you append REDEFINE
	# 
	obj_bindimport(${obj} anyfunction myBoundFunc REDEFINE)
	myBoundFunc()
	# print the object



	## extended a 'type'
	## =================
```

# Simple Inheritance Example

See the following for  a very verbose sample of inheritance (one of the first ones)

```
cmake_minimum_required(VERSION 2.8)
# include standalone version of oo-cmake
# when not using cutil this  includes the function files as well as
# the dependent functions
include("../oo-cmake.cmake")

message("creating a simple inheritance example")

#create animal object
obj_create(animal)

# set object method eat
# this method prints out which food the animal is eating
# existing functions can also be applied via obj_bindcall(${ref} func arg1 arg2 arg3)

obj_setfunction(
	${animal} 
	"function(eat result)\n  obj_get(\${this} food food) \n  \n return_value(\"I eat \${food}\") \n endfunction() "
)



# create mamal object
obj_create(mamal)
obj_setprototype(${mamal} ${animal})

#create bird object
obj_create(bird)					#create instance
obj_setprototype(${bird} ${animal})	#set prototype animal
obj_set(${bird} food Birdfood)		#set bird's food property to "Birdfood"

#create dog object
obj_create(dog)						#create instance
obj_setprototype(${dog} ${mamal})	#set prototype mamal
obj_set(${dog} food Dogfood)		#set dogs food property to "Dogfood"

#create cat object
obj_create(cat)						#create instance
obj_setprototype(${cat} ${mamal})	#set prototype mamal
obj_set(${cat} food Catfood)		#set cat's food property to "Catfood"


# call eat function for different objects
obj_callmember(${bird} eat) 
obj_callmember(${dog} eat)
obj_callmember(${cat} eat)

#output should be
#I am eating Birdfood
#I am eating Dogfood
#I am eating Catfood

```

### Motivation
Object oriented programming is great! CMake does not support it, until now! It really sucks that kitware decided to use their own language (with very little high level language features) as their build system product.  I can understand that it seemed like a good idea at first ( the cmake language is platform independent and easier to use than make or bash or cmd). I  however  strongly believe that building a programm should be as easy as possible and therefore a high level language should have been used. CMake's creator has said that he would have done this differently if he had to do it again (http://www.aosabook.org/en/cmake.html)

For more complex build system features oo programming would be a major boon.  So I took it upon myself to create something usable and tested enough so I could continue developing and extending my plattform independent tooling support (cutil) for cmake.

Of course CMake does not offer language features to make it very sleak but the with these functions you can use prototypical inheritance, maps, objects, lists, properties, references, etc. which are at the basis of every oo language.

People familiar with JavaScript will be familiar with this appoach.  I will write a couple of tutorials in the future. Currently you will have to look at the tests / docs to learn how to use the commands.  

You can use the following commands

```
obj_create(out_ref [objectpath]) 		#returns a ref to a new object. this object is persistent and will exist until obj_delete is called, internally the object is represented by a folder
obj_delete(in_ref) 						# deletes a object (deletes the folder internally)
obj_find(refOrId)						# searches for a named object or id
obj_get(ref value  key)					# gets a property  ${value} = ref[key] the prototype chain is considered
obj_set(ref key value)					# sets a property  ref[key] = value
obj_getref(ref prop_ref key)			# returns the reference to a property (a file)
obj_getownproperty(ref value key)		# returns the value for property if the property belongs to ref	
obj_setownproperty(ref key value)   	# sets the own property ref[key] =value
obj_has(ref result key)					# sets result to true if ref[key] exists
obj_hasownproperty(ref result key)	 	# sets result to true if ref[key] exists and is owned by ref
obj_callmember(ref methodname args...)	# calls a stored memberfunction (first argument passed is ref)
obj_bindcall(ref methodname args...)	# calls a defined function setting first argument to ref
obj_setprototype(ref proto_ref)			# sets the prototype for ref
obj_getprototype(ref proto_ref)			# returns the prototyp for ref
obj_settype(ref type) 					# sets the type for ref
obj_gettype(ref type) 					# gets the type for ref
obj_getkeys(ref keys) 					# returns all defined properties for ref
obj_getownkeys(ref keys)				# returns all defined properties that ref owns

```

#### Possible Extensions

##### More special fields 

Similar to javascript I might allow more special fields like `__getter__`, `__setter__`, `__call__`, `__construct__`, __destruct__`  etc. this would allow for computed properties, events, etc.

##### Resource Management

currently the user is responsible for creating and deleting objects herself. Maybe it is possible to do some kind of memory management. (It could be a scheme based on object type (temporary, persistent, longtime persistent))  Reference counting would be cool, however I do not believe it is feasible in cmake.  

##### Memory based oo-cmake
It would be quite possible to have a memory based object oriented package which should prove to be alot faster.  However I have not thought of a way to combine the two.

The idea would be to use get_cmake_property(VARIABLES) for a list of available cmake variables (getkeys) and store objects as underscore separated lists. '__object1__val1 = a;b;c'
