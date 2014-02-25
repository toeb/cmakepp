oo-cmake
========

objects, methods, functions, maps, inheritance, oo-cmake goodness

# Installing

Download the code and include `oo-cmake.cmake` in your `CMakeLists.txt` (or other cmake script)
be sure to use an up to date version of cmake.  `oo-cmake.cmake` adds this:

```
cmake_minimum_required(VERSION 2.8.12)
cmake_policy(SET CMP0007 NEW)
cmake_policy(SET CMP0012 NEW)
```
# Testing

To test the code (alot is tested but not all) run the following in the root dir of oo-cmake 
``` 
cmake -P oo-cmake-tests.cmake 
```

# Functions

To correctly work with object oriented programming in cmake dynamic functions are a must
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