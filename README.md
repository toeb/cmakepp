![cps logo](/logo.png "cps logo")

## pure cmake object oriented scripting

[![Build Status](https://travis-ci.org/toeb/oo-cmake.png?branch=devel)](https://travis-ci.org/toeb/oo-cmake)
[![Project Stats](https://www.ohloh.net/p/oo-cmake/widgets/project_thin_badge.gif)](https://www.ohloh.net/p/oo-cmake)
objects, methods, functions, maps, inheritance, parsers, lists, ...
# Installing

Download the code and include `oo-cmake.cmake` in your `CMakeLists.txt` (or other cmake script)
be sure to use an up to date version of cmake. `oo-cmake` requires cmake version `>=3.0.0` most of its functions also work with `2.8.7`

# Usage
Look through the files in the package.  Most functions will be commented and the other's usage can be inferred.  All functions are avaiable as soon as you include the oo-cmake.cmake file.

# Testing
To test the code (alot is tested but not all) run the following in the root dir of oo-cmake 

``` 
cmake -P oo-cmake-tests.cmake 
```

# Feature Overview

`oocmake` is a general purpose library for cmake.  It contains functionality that was missing in my opinion and also wraps some cmake functionality to fit to the style of this library.

* Features
	* [interactive cmake console](#icmake) (`cmake -P icmake.cmake`)
	* [eval](#eval) - evaluates cmake code and is the basis of many advanced features
	* [shell](#shell) - "platform independent" shell script execution
		* [aliases](#aliases) - platform independent shell aliases
		* [console](#console) - functions for console input and output
	* [filesystem](#filesystem) - directory and file functions with close relations to bash syntax
		* [compression/decompression](#compression) - compressing and decompressing tgz and zip files
	* [command execution](#execute) simplifying access to exectables using the shell tools.
	* [cmake tool compilation](#tooling) simple c/c++ tools for cmake
	* debugging
		* some convenience functions
		* `breakpoint()` - stops execution at specified location and allows inspection of cmake variables, execution of code (if `-DDEBUG_CMAKE` was specified in command line)
	* [version control systems](#vcs)
		* `hg()` convenience function for calling mercurial vcs
		* `git()` convenience function for calling git vcs
		* `svn()` convenience function for calling subversion vcs
		* utility methods for working with the different systems
	* [cmake](#cmake) calling cmake from cmake.
	* [date/time](#datetime)
	  * function for getting the correct date and time on all OSs
	  * get milliseconds since epoch
	* [events](#events) allows registering event handlers and emitting events
	* [Windows Registry](#windowsregstry)
		* `reg()` shorthand for working with windows registry command line interface
		* read write manipulate registry values
		* query registry keys for values
	* [string functions](#stringfunctions) - advanced string manipulation		
	* [lists](#lists) - extension to cmake and normalization of cmake's `list()` functionality
	* [maps](#maps) - map functions and utility functions (nested data structures for cmake)
		* graph algorithms 
		* serialization/deserialization
			* [json](#json)
			* [quickmap format](#quickmap) (native to cmake)
			* [xml](#xml)
	* [user data](#userdata) - persists and retrieves data for the current user (e.g. allowing cross build/ script configuration)
	* [expression syntax](#expr).
			* `obj("{id:1,prop:{hello:3, other:[1,2,3,4]}}")` -> creates the specified object
	* functions
		* [returning values](#return)
		* define dynamic functions (without cluttering the namespace)
		* call functions dynamically (basically allowing `${functionName}(arg1 arg2 ...)` by typing  `call(${functionName}(arg1 arg2 ...))`)
		* set a variable to the result of functions `rcall(result = somefunction())`
		* lambda functions (a shorthand syntax for defining inline functions.  `(var1,var2)-> do_somthing($var1); do_something_else($var2)` 
		* import functions (from files, from string, ...)
	* [objects](#objects) - object oriented programming with prototypical inheritance, member functions
	* [process management](#process_management) - platform independent forking, waiting, controlling separate process from cmake 
	* [Targets](#targets)
		* [access to a list of all defined targets](#target_list)
		* easier access to target properties
		* 
	* [implementation notes](#implementation_notes)


NOTE: the list is incomplete
# <a name="icmake"></a>Interactive CMake Shell

If you want to learn try or learn cmake and `oocmake` you can use the interactive cmake shell by launching `cmake -P icmake.cmake` which gives you a prompt with the all functions available in `oocmake` and cmake in general.

`icmake` allows you to enter valid cmake and also a more lazily you can neglect to enter the parentheses around functions e.g. `cd my/path ` -> `cd(my/path)`

Since console interaction is complicated with cmake and cmake itself is not very general purpose by design the interactive cmake shell is not as user friendly as it should be.  If you input an error the shell will terminate because cmake terminates. This problem might be addressed in the future (I have an idea however not the time to implement and test it)
Example:
```
> ./icmake.sh
icmake> cd /usr/tobi
"/usr/tobi"
icmake> pwd
"/usr/tobi"
icmake> @echo off
echo is now off
icmake> pwd
icmake> message("${ANS}")
/usr/tobi
icmake> @echo on
echo is now on
icmake> function(myfunc name)\  # <-- backslash allows multiline input
	        message("hello ${name}") \
	        obj("{name: $name}")\
	        ans(person)\
	        return(${person})\
        endfunction()
"/usr/tobi"                 # <-- the last output of any function is always repeated. 
icmake> myfunc Tobi
hello Tobi  				# <-- output in function using message
{"name":"Tobi"} 			# <-- json serialized return value of function
icmake> quit
icmake is quitting
> 
```


# Formalisms 

To describe cmake functions I use formalisms which I found most useful they should be intuitively understandable but here I want to describe them in detail.



* `@` denotes character data
* `<string> ::= "\""@"\""` denotes a string literal
* `<regex> ::= /<string>/` denotes a regular expression (as cmake defines it)
* `<identifier> ::= /[a-zA-Z0-9_-]+/` denotes a identifier which can be used for definitions
* `<datatype> ::= "<" "any"|"bool"|"number"|""|"void"|""|<structured data> <?"...">">"` denotes a datatype the elipses denotes that multiple values in array form are described else the datatype can be `any`, `bool`, `number`, `<structured data>` etc.. 
* `<named definitiont> ::= "<"<identifier>">"`
* `<definition> ::= "<"<?"?"><identifier>|<identifier>":"<datatype>|<datatype>>">"`  denotes a possibly name piece of data. this is used in signatures and object descriptions e.g. `generate_greeting(<firstname:<string>> <?lastname:<string>>):<string>` specifies a function which which takes a required parameter called `first_name` which is of type `string` and an optional parameter called `lastname` which is of type `string` and returns a `string`
* `<structured data> ::= "{"<? <named definition> ...>"}"`
* `<void>` primitve which stand for nothing
* `<falseish>:"false"|""|"no"` cmake's false values (list incomplete)
* `<trueish>: !<falseish>`
* `<bool> ::= "true":"false"` indicates a well defined true or false value
* `<boolish> ::= <trueish>|<falsish>|<bool>`
* `<any> ::= <string>|<number>|<structured data>|<bool>|<void>`
* ... @todo


# <a name="return"></a>Returning values

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


# <a name="maps"></a> Maps

Maps are very verstile and are missing from CMake. Due to the "variable variable" system (ie names of variables are string which can be generated from other variablees) it is very easy to implement the map system. Under the hood a value is mapped by calling `ref_set(${map}.${key})` 

## Functions
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

# some specialized functions
map_append()
map_append_string()

```

## Easy map handling with `nav()`

Using the functions metnioned before can be cumbersome. Therefore I have added a universial function called `nav()` It allows you to use statements known from other programming languages. 


### Example

```
set(myvar hello) # typical cmake assign statement
nav(mymap.prop1 = myvar) # creates the variable mymap and sets its prop1 field to the value of myvar
assert(DEREF {mymap.prop1} STREQUAL "hello") # assert allows map navigation replacing {<expr>} with the result of nav(<expr>)

nav(mymap.prop2 myvar) # creates the property prop2 on mymap and assigns the value myvar
assert(DEREF {mymap.prop2} STREQUAL "myvar")

nav(res = mymap.prop1) # sets res to the value of mymap.prop1
assert("${res}" STREQUAL "hello")

nav(res FORMAT "{mymap.prop1}-{mymap.prop2}") #you can also format a string using the {} syntax
assert("${res}" STREQUAL "hello-myvar") 

nav(a.b.c.d.e 3) # 
json(${a})
ans(res)
assert(${res} STREQUAL "{\"b\":{\"c\":{\"d\":{\"e\":3}}}}")

```
### Caveats 
* objects are created on the fly
* nav is slow because it uses a lot of regex and loops to parse the expressions


## <a name="xml"></a> Naive Xml Deserialization

Xml Deserialization is a complex subject in CMake.  I have currently implemented a single naive implementation based on regular expressions which *does not* allow recursive nodes (ie nodes with the same tag being child of one another).



### Functions

* `xml_node(<name> <value> <attributes:object>)->{ tag:<name>, value:<value>, attrs:{<key>:<value>}}`  creates a naive xml node representation.
* `xml_parse_nodes(<xml:string> <tag:string>)-> list of xml_nodes`  this function looks for the specified tag in the string (matching every instance(no recursive tags)) it parses the found nodes attributes and value (innerXml). You can then use `nav()`, `map_get()` etc functions to parse the nodes




## <a name="json"></a>Json Serialziation and Deserialization

I have written five functions which you can use to serialize and deserialize json.  

### Functions

* `json(<map>)` 
    - transforms the specified object graph to condensed json (no superfluos whitespace)
    - cycles are detected but not handled. (the property will not be set if it would cause a cycle e.g. map with a self reference would be serialized to `{"selfref":}` which is incorrect json... which will be addressed in the future )  
    - unicode is not transformed into `\uxxxx` because of lacking unicode support in cmake
* `json_indented(<map>)` 
    - same as `json()` however is formatted to be readable ie instead of `{"var":"val","obj":{"var":["arr","ay"]}}` it will be 
```
{
	"var":"var",
	"obj":[
		"arr",
		"ay"
	]
}
```
* `json_deserialize(<json_string>)`
	- deserialized a json string ignoring any unicode escapes (`\uxxxx`)
* `json_read(<file>)`
	- directly deserializes af json file into a map
* `json_write(<file> <map>)`
	- write the map to the file

### Caveats
As can be seen in the functions' descriptions unicode is not support. Also you should probably avoid cycles.  

### Caching
Because deserialization is extremely slow I chose to cache the results of deserialization. So the first time you deserialize something large it might take long however the next time it will be fast (if it hasn't changed).
This is done by creating a hash from the input string and using it as a cache key. The cache is file based using Quick Map Syntax (which is alot faster to parse since it only has to be included by cmake).  

## <a name="quickmap"></a>Quick Map Syntax
To quickly define a map in cmake I introduce the quick map syntax which revolves around these 5 functions and is quite intuitive to understand:
```
map([key]) # creates, returns a new map (and parent map at <key> to the new map) 
key(<key>)	# sets the current key
val([arg ...])	# sets the value at current map[current key] to <args>
kv(<key> [arg ...]) # same as writing key(<key>) LF val([arg ...]) 
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
 		kv(name oo-cmake)
 		kv(url https://github.org/toeb/oo-cmake)
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
						# if the code returns something (see return)
						# the result will be available after eval() using ans()
eval_ref(<var>)         # executes the given code
						# since this is a macro the code is passed as a variable name
						# however this allows using set(PARENT_SCOPE) 
function_new()			# returns a unqiue name for a function
function_import(function_ish as function_name) # imports a function under the specified name
call(function_ish([args ...])) # calls a function
function_info(function_ish)	# returns info on name, arguments, type of function
function_inject(function_ish)	# imports a function, injecting before call, after call data
```

## Function Patterns

### <a href="initializer_function"></a> Initializer function

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

# <a name="objects"></a>Objects 

Objects are an extension of the maps. I split up maps and objects because objects are a lot slower (something like 2x-3x slower) and if you do not need objects you should not use them (handling 1000s of maps is already slow enough).

However I hope that soon CMake will provide the functionality needed to make all this faster.


## Functions
These are the basic functions which are available (there are more which all use these basic ones): 
```
new([Constructor]) returns a ref to a object
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



## Example

This is how you define prototypes and instanciate objects.  

The syntax seems a bit strange and could be made much easier with a minor change to CMake... Go Cmake Gods give me true macro power! (allow to define a macro which can call function() and another which contains endfunction()) /Rant



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


# <a name="semver"></a>Parsing and handling semantic versions


A `semantic version` gives a specific meaning to it components. It allows software engineers to quickly determine weather versioned components of their software can be updated or if breaking changes could occur.  

On [semver.org](http://semver.org/) Tom Preston-Werner defines Semantic Versioning 2.0.0 which is recapped in the following.

A `semantic version` is defined by is a version string which is in the following format whose components have a special semantic meaning in regard to the versioned subject:
```
<version number> ::= (0|[1-9][0-9]*)
<version tag> ::= [a-zA-Z0-9-]+
<major> ::= <version number>
<minor> ::= <version number>
<patch> ::= <version number>
<prerelease> ::= <version tag>[.<version tag>]*
<metadata> ::= <version tag>[.<version tag>]*
<semantic_version> ::= <major>.<minor>.<patch>[-<prerelease>][+<metadata>]

```
## Examples

* `1.3.42-alpha.0+build-4902.nightly`
* `4.2.1`
* `0.0.0`

## Description

A `version number` may be any `0` or any positive integer. It may not have leading `0`s. 

`major` is a `version number`.

A `version tag` non-empty alphanumeric string (also allowed: hyphen `-`)

`prerelease` is a period `.` separated list of a `version tag`s. A version with `prerelease` is always of a lower order than a the same version without `prerelease`. 

`<metadata>` is a list of period `.` separated `version tag`s with no meaning to the `semantic version`. It can be considered as user data.

## Semantics

`major` is a `version number`.  `0` signifies that the public interface (API) of a package is not yet defined. The first major version `1` defines the public interface for a package. If the `major` version changes backwards incompatible changes have occured.

`minor` is a `version number` which signifies a backwards compatible change in the public interface of a package.  Updating a package to a new minor version MAY NOT break the dependee.

`patch` is a `version number`  which signifies a change in the internals of a package. ie bugfixes, inner enhancements. 

A `version number` SHOULD be incremented by `1` and `version number` the lower `version number`s are reset to zero. Incrementing a version with prerelease has to be done manually e.g.

* increment `major` `1.23.1` => `2.0.0` 
* increment `minor` `1.23.1` => `1.24.0`
* increment `patch` `1.23.1` => `1.23.2`

## Semantic Version Object

The sematic version object is the following map:

```
{
    "string":"<major>.<minor>.<patch>-<prerelease>+<metadata>"
    "numbers":"<major>.<minor>.<patch>",
    "major":"<major>",
    "minor":"<minor>",
    "patch":"<patch>",
    "prerelease":"<prerelease>",
    "metadata":"<metadata>",
    "tags":[
        <version tag>,
        <version tag>,
        ...
    ],
    "metadatas":[
        <version tag>,
        <version tag>,
        ...
    ]

}
```
## Constraining Versions

A `version constraint` constrains the set of all version to a subset.

```
<version operator> ::= >=|<=|>|<|=|~|! 
<version constraint> ::= <version constraint>"|"<version constraint> 
<version constraint> ::= <version constraint>","<version constraint>
<version constraint> ::= <version operator><lazy version>
```

* `<version constraint> ::= <- <package_version_constraint> , <package_version_constring>` can be AND combined. `,` is the and operator and it has precedence before 
* `<package_version_constraint> <- <package_version_constraint> | <package_version_constring>`: `<package_version_constraint>`s can be or combined
* `<package_version_constraint_operator><package_version>`
* `<package_version_constraint_operator><lazy_version>`
* `<package_version>` -> `~<package_version>`
* `<lazy_version>`
* `<lazy_version>` is a `<package_version>` which may  miss elements. These elements are ie `1` would correspond to `1.0.0`
* a `<package_version_constraint_operator>` can be one of the following
    - `=` `<package_version>`  equals the specified version exactly
    - `<` `<package_version>` is less up to date then specified version
    - `>` `<package_version>` is greater than specified version
    - `>=` `<package_version>` is greater or equal to specified version evaluates to `><package_version> | =<package_version>`
    - `<=` `package_version` is less or equal than specified version evaluates to `<<package_version> | =<package_version>`
    - `~` 





## Lazy Version

A `lazy version` a less strict formulation of a `sematic version` 
```
<lazy version> ::= [whitespace]<<sematic_version>|v<lazy_version>|<major>|<major>.<minor>|"">[whitespace]
```

A lazy version allows whitesspace and omission of `minor` and `patch` numbers. It also allows a preceding `v` as is common in many versioning schemes.

A `lazy version` can be normalized to a strict `semantic version` by removing any whitespace around and in the version as well as the leading `v`, and filling up missing `major` and `minor` and `patch` version components with `0`. Normalizing an empty (or pure whitespace) string results in version `0.0.0`

*Examples*
* `v1.3` => `1.3.0`
* `v1-alpha` => `1.0.0-alpha`
* `v1.3-alpha` => `1.3.0-alpha`
* `1` => `1.0.0`
* `  1    ` => `1.0.0`
* `     `=> `0.0.0`
* 
## Functions

The following functions are usable for semantic versioning.

* `semver(<lazy_version>)` parses a string or a semantic version object and returns a `<semantic version object>`
	- `semver(1.0)` => `{major:1,minor:0,patch:0}`
	- `semver(2-alpha+build3.linux)` => `{major:2,minor:0,patch:0,prerelease:['alpha'],metadata:['build3','linux']}`
	- `semver(2.3.1-beta.3+tobi.katha)` => `{major:2,minor:3,patch:1,prerelease:['beta','3'],metadata:['tobi','katha']}`
* `semver_compare(<lhs:semverish> <rhs:semverish>)` compares two semantiv versions.
	- returns `-1` if left is more up to date
	- returns `1` if right is more up to date
	- returns `0` if they are the same
* `semver_higher(<lhs:semverish> <rhs:semverish>)` returns the semantic version which is higher.
* `semver_gt(<lhs:semverish> <rhs:semverish>)` returns true iff left semver is greater than right semver
* `semver_cosntraint_evaluate(<version constraint> <lazy_version>)` returns true if `<lazy_version>` satisfies `<version cosntraint>`
	- `semver_constraint_evaluate("=0.0.1" "0.0.1")` -> true
	- `semver_constraint_evaluate("=0.0.1" "0.0.2")` -> false
  	- `semver_constraint_evaluate("!0.0.1" "0.0.1")` -> false
  	- `semver_constraint_evaluate("!0.0.1" "0.0.2")` -> true
    - `semver_constraint_evaluate(">0.0.1" "0.0.2")` -> true
  	- `semver_constraint_evaluate(">0.0.1" "0.0.1")` -> false
    - `semver_constraint_evaluate("<0.0.1" "0.0.0")` -> true
    - `semver_constraint_evaluate("<0.0.1" "0.0.1")` -> false
    - `semver_constraint_evaluate("<=3,>2" "3.0.0")` -> true
    - `semver_constraint_evaluate("<=3,>=2" "2.0.0")` -> true


## Caveats

* parsing, constraining and comparing semvers is slow. Do not use too much (you can  compile a semver constraint if it is to be evaluated agains many versions which helps a little with performance issues).  


# <a name="targets"></a> Targets

## target_list and project_list

CMake as of version 2.8.7 does not support a list of all defined targets.
Therfore I overwrote all target adding functions `add_library`, `add_executable`, `add_custom_target`, `add_test`, `install` ... which now register the name of the target globally in a list. You can access this list by using the function `target_list()` which returns the list of known target names .  Note that only targets defined before the `target_list()`  call are known.  

I did the same thing for the  `project()` command.

## target debug functions

To quickly get an overview of how your target is configured write `print_target(<target_name>)` it will print the json representation of the target as a message.

To see how were all your targetes are type `print_project_tree` which will show the json representation of all your prrojects and targets.

## target property functions

accessing target properties made easier by the following functions

* `target_get(<target> <prop-name>)` returns the value of the target property
* `target_set(<target> <prop-name> [<value> ...])` sets the value of the target property
* `target_append(<target> <prop-name> [<value> ...])` appends the values to the current value of `<prop-name>` 
* `target_has(<target> <prop-name>)->bool` returns true iff the target has a property called `<prop-name>`



# <a name="windowsregistry"></a> Windows Registry


Even though cmake and oocmake are platform independent working with the windows registry is sometimes import/ e.g. setting environment variables. The cmake interface for manipulating registry values is not very nice (`cmake -E delete_regv` `write_regv`, `get_filename_component(result [HKEY_CURRENT_USER/Environment/Path] ABSOLUTE CACHE)` ) and hard to work with. Therefore I implemented a wrapper for the windows registry command line tool [REG](http://technet.microsoft.com/en-us/library/cc732643.aspx) and called it `reg()` it has the same call signature as `REG` with a minor difference: what is `reg add HKCU/Environment /v MyVar /f /d myval` is written `reg(add HKCU/Environment /v /MyVar /f /d myval)`. See also [wrap_executable](#executable)


## Availables Functions


Using this command I have added convinience functions for manipulating registry keys and values

* `reg()` access to REG command line tool under windows (fails on other OSs)
* `reg_write_value(key value_name value)` writes a registry value (overwrites if it exists)
* `reg_read_value(key value_name)` returns the value of a registry value
* `reg_query_values(key)` returns a map containing all values of a specific registry key
* `reg_append_value(key value_name [args...])` append the specified values to the registries value
* `reg_prepend_value(key value_name [args...])` prepends the specified values to the registries value
* `reg_append_if_not_exists(key value_name [args ...]) appends the specifeid values to the registries value if they are not already part of it, returns only the values which were appended as result
* `reg_remove_value(key value_name [args ...])` removes the specified values from the registries value
* `reg_contains_value(key value_name)` returns true iff the registry contains the specified value
* `reg_query(key)` returns a list of `<reg_entry>` objects which describe found values
* `<reg_entry>` is a object with the fields key, value_name, value, type which describes a registry entry



## Using windows registry functions example


```
set(kv HKCU/Environment testValue1)

## read/write
reg_write_value(${kv} "b;c")
reg_read_value(${kv})
ans(res)
assert(EQUALS ${res} b c)

## append
reg_append_value(${kv} "d")
reg_read_value(${kv})
ans(res)
assert(EQUALS ${res} b c d)

## prepend
reg_prepend_value(${kv} "a")
reg_read_value(${kv})
ans(res)
assert(EQUALS ${res} a b c d)


## append if not exists
reg_append_if_not_exists(${kv} b c e f)
ans(res)
assert(res)
assert(EQUALS ${res} e f)
reg_read_value(${kv})
ans(res)
assert(EQUALS ${res} a b c d e f)


## remove
reg_remove_value(${kv} b d f)
reg_read_value(${kv})
ans(res)
assert(EQUALS ${res} a c e)


## contains
reg_contains_value(${kv} e)  
ans(res)
assert(res)


## read key
reg_query_values(HKCU/Environment)
ans(res)
json_print(${res})
assert(EQUALS DEREF {res.testValue1} a c e)
```
# <a name="datetime"></a> Date/Time

I have provided you with a functions which returns a datetime object to get the current date and time on all OSs including windows. It uses file(TIMESTAMP) internally so the resolution is 1s.  It would be possible to enhance this functionality to included milliseconds however that is more system dependent and therefore a decieded against it.  

`datetime()` currently only returns the local time. extending it to return UTC would be easy but I have not yet needed it

In the future date time arithmetic might be added

## Functions

* `datetime()` returns the current date time as a `<datetime object>`
* `<datetime object>` an object containing the following fields: `yyyy` `MM` `dd` `hh` `mm` `ss`




# <a name="eval"></a> Eval

`eval()` is one of the most central functions in oocmake.  It is the basis for many hacks an workarounds which oocmake uses to enhance the scripting language.

`eval` is not native to cmake (native eval would greatly increase the performance of this library) 

Internally it works by writing cmake script to a file and including it

## Functions

* `eval(code)` executes the specified code. `set(x z PARENT_SCOPE)` is not however you can return a value. 

## Examples

Defining a Function and calling it

```
eval("
function(say_hello name)
	return(\"hello \${name}!\") # note: escape cmake double quotes and dolar sign in front of vars
endfunction()
")

say_hello(Tobias)
ans(res)
assert("${res}" STREQUAL "hello Tobias!")

```

dynamically calling a function

```
# three handlers
function(handler1 a)
	return("handler1 ${a}")
endfunction()
function(handler2 a)
	return("handler2 ${a}")
endfunction()
function(handler3 a)
	return("handler3 ${a}" )
endfunction()
# list of handlers
set(handlers handler1 handler2 handler3)
# intialize result
set(results)
# set input value
set(val 3)
foreach(handler ${handlers})
	# dynamically call handler
	eval("${handler}(${val})")	
	ans(res)
	# append result to list
	list(APPEND results ${res})
endforeach()
# check if list equals expected results
assert(EQUALS ${results} "handler1 3" "handler2 3" "handler3 3")
```


# <a name="events"></a> Events

Events are often usefull when working with modules. CMake of course has no need for events generally. Some of my projects (cutil/cps) needed them however. For example the package manager cps uses them to allow hooks on package install/uninstall/load events which the packages can register.


## Example


```
# create an event handler
function(my_event_handler arg)
 message("${event_name} called: ${arg}")
 return("answer1")
endfunction()

# add an event handler
event_addhandler(irrelevant_event_name my_event_handler)
# add lambda event handler
event_addhandler(irrelevant_event_name "(arg)->return($arg)")
# anything callable can be used as an event handler (even a cmake file containing a single function)

# emit event calls all registered event handlers in order
# and concatenates their return values
# side effects: prints irrelevent_event_name called: i am an argument
event_emit(irrelevant_event_name "i am an argument")
ans(result)


assert(EQUALS ${result} answer1 "i am an argument")
```

## Functions and Datatypes

* `<event id>` a globally unique identifier for an event (any name you want except `on_event` )
* `on event` a special event that gets fired on all events (mainly for debugging purposes)
* `event_addhandler(<event id> <callable>)` registers an event handler for the globally unique event identified by `<event id>` see definition for callable in [functions section](#functions)
* `event_removehandler(<event id> <callable>)` removes the specified event handler from the handler list (it is no longer invoked when event is emitted)
* `event_emit(<event id> [arg ...]) -> any[]` invokes the event identified by `<event id>` calls every handler passing along the argument list. every eventhandler's return value is concatenated and returned.  It is possible to register event handlers during call of the event itself the emit routine continues as long as their are uncalled registered event handlers but does not call them twice.
* ... (functions for dynamic events, access to all available events)

# <a name="vcs"></a> Version Control System utilities

Working with the version control system can be a crutch in CMake. Therefore I created helpers and convenience functions which allow simple usage. Consider the following CMake code which you would have to use to clone cutil's git repository

```

find_package(Git)
if(NOT GIT_FOUND)
	message(FATAL_ERROR "Git is required!")
endif()
set(cutil_base_dir "/some/path")
if(NOT IS_DIRECTORY "${cutil_base_dir}")
	if(EXISTS "${cutil_base_dir}")
		message(FATAL_ERROR "${cutil_base_dir} is a file")
	endif()
	file(MAKE_DIRECTORY "${cutil_base_dir}")
endif()
execute_process(COMMAND "${GIT_EXECUTABLE}" clone "https://github.com/toeb/cutil.git" "${cutil_base_dir}" RESULT_VARIABLE error ERROR_VARIABLE error)
if(error)
	message(FATAL_ERROR "could not clone https:// .... because "${error}")
endif()
execute_process(COMMAND "${GIT_EXECUTABLE}" submodule init WORKING_DIRECTORY "${cutil_base_dir}" RESULT_VARIABLE error)
if(error)
	message(FATAL_ERROR "could not init submodules because "${error}")
endif()
execute_process(COMMAND "${GIT_EXECUTABLE}" submodule update --recursive WORKING_DIRECTORY "${cutil_base_dir}" RESULT_VARIABLE error)
if(error)
	message(FATAL_ERROR "could not update submodules")
endif()
```

Using convenience functions this distills down to

```
# set the current directory to ${cutil_base_dir} and creates it if it does not exist
cd(${cutil_base_dir} --create) 
# automatically fails on error with error message
git(clone "http://github.com/toeb/cutil.git" .)
git(submodule init)
git(submodule update --recursive)
```

So alot of unecessary repeating code can be omitted.  

## Git

### Functions

* `git()` function for git command line client with same usage, except `git ...` -> `git(...)` (created using wrap_executable)
* `git_base_dir([<unqualified path>]) -> <qualified path>` returns the repositories base directory
* `git_dir([<unqualified path>]) -> <qualified path>` returns the repositories .git directory 
* `git_read_single_file(<repository uri> <branch|""> <repository path>) -> <content of file>` reads a file from a remote repository
* `git_remote_exists(<potential repository uri>) -> bool` returns true if the uri points to a valid git repository
* `git_remote_refs(<repository uri>) -> <remote ref>[]` returns a list of `<remote ref>` objects
* `<remote ref>` a objects containing the following fields
  * `type : HEAD | <branch name>` -> the type of ref
  * `name : <string>` -> the name of the ref 
  * `revision: <hash>` -> the revision associated with the ref
* `git_repository_name() -> <string>`  returns the name of the repository. 

## Subversion

* `svn()` function for svn command line client with same usage, except `svn ...` -> `svn(...)` (created using wrap_exetuable)
* `svn_get_revision(<uri>)` returns the revision number of the specifed `<uri>`
* `svn_info(<uri>)-><svn info>` returns an object containing the following fields
	- path: specified relative path
	- revision: revision number
	- kind
	- url: uri
	- root: repository root
	- uuid
* ...

## Mercurial

* `hg()` function for mercurial command line client with same usage except `hg ...` -> `hg(...)`
* ...

# <a name="execute"></a> # Executing External Programms

Using external applications more complex than necessary in cmake imho. I tried to make it as easy as possible.  Wrapping an external programm is now very simple as you can see in the following example for git:

This is all the code you need to create a function which wraps the git executable.  It uses the [initializer function pattern](#initializer_function). 

```
function(git)
  # initializer block (will only be executed once)
  find_package(Git)
  if(NOT GIT_FOUND)
    message(FATAL_ERROR "missing git")
  endif()
  # function redefinition inside wrap_executable
  wrap_executable(git "${GIT_EXECUTABLE}")
  # delegate to redefinition and return value
  git(${ARGN})
  return_ans()
endfunction() 
```

Another example:

```
find_package(Hg)
set(cmdline --version)
execute({path:$HG_EXECUTABLE, args: $cmdline} --result)
ans(res)
map_get(${res} result)
ans(error)
map_get(${res} output)
ans(stdout)
assert(NOT error) # error code is 0
assert("${stdout}" MATCHES "mercurial") # output contains mercurial
json_print(${res}) # outputs input and output of process

```

## Functions and Datatypes

* `execute(<process start ish> [--result|--return-code]) -> <stdout>|<process info>|<int>` executes the process described by `<process start ish>` and by default fails fatally if return code is not 0.  if `--result` flag is specified `<process info>` is returned and if `<return-code>` is specified the command's return code is returned.  (the second two options will not cause a fatal error)
	* example: `execute("{path:'<command>', args:['a','b']}")`  
* `wrap_executable(<name:string> <command>)`  takes the executable/command and wraps it inside a function called `<name>` it has the same signature as `execute(...)`
* `<process start ish>` a string which can be converted to a `<process start>` object
* `<process start>` a map/object containing the following fields
	- `path` command name / path of executable *required*
	- `args` command line arguments to pass along to command, use `string_semicolon_encode` if you want to have an argument with semicolons *optional*
	- `timeout:<int>` *optional* number of seconds to wait before failing
	- `cwd:<unqualified path>` *optional*  by default it is whatever `pwd()` currently returns
* `<process info>` contains all the fields of `<process start>` and additionaly
	- `output:<stdout>`  the output of the command execution. (merged error and stdout streams)
	- `result:<int>` the return code of the execution.  0 normally indicates success.



# <a name="filesystem"></a> Filesystem

I have always been a bit confused when working with cmake's file functions and the logic behind paths (sometimes they are found sometimes they are not...) For ease of use I reimplemented a own path managing system which behaves very similar to powershell and bash (see [ss64.com](http://ss64.com/bash/)) it is based around a global path stack and path qualification. All of my functions which work with paths use this system. To better show you what I mean I created the following example:

```
# as soon as you include `oo-cmake.cmake` the current directory is set to 
# "${CMAKE_SOURCE_DIR}" which is the directory from which you script file 
# is called in script mode (`cmake -P`) or the directory of the root 
# `CMakeLists.txt` file in configure and build steps.
pwd() # returns the current dir
ans(path)

assert("${path}" STREQUAL "${CMAKE_SOURCE_DIR}")


pushd("dir1" --create) # goto  ${CMAKE_SOURCE_DIR}/dir1; Create if not exists
ans(path)
assert("${path}" STREQUAL "${CMAKE_SOURCE_DIR}/dir1")

fwrite("README.md" "This is the readme file.") # creates the file README.md in dir1
assert(EXISTS "${CMAKE_SOURCE_DIR}/dir1/README.md") 


pushd(dir2 --create) # goto ${CMAKE_SOURCE_DIR}/dir1/dir2 and create it if it does not exist
fwrite("README2.md" "This is another readme file")

cd(../..) # use relative path specifiers to navigate path stack
ans(path)

assert(${path} STREQUAL "${CMAKE_SOURCE_DIR}") # up up -> we are where we started

popd() # path stack is popped. path before was ${CMAKE_SOURCE_DIR}/dir1
ans(path)

assert(${path} STREQUAL "${CMAKE_SOURCE_DIR}/dir1")


mkdir("dir3")
cd(dir3)
# current dir is now ${CMAKE_SOURCE_DIR}/dir1/dir3

# execute() uses the current pwd() as the working dir so the following
# clones the oo-cmake repo into ${CMAKE_SOURCE_DIR}/dir1/dir3
git(clone https://github.com/toeb/oo-cmake.git ".")


# remove all files and folders
rm(.)


popd() # pwd is now ${CMAKE_SOURCE_DIR} again and stack is empty

```


## Functions and datatypes

* `<windows path>`  a windows path possibly with and possibly with drive name `C:\Users\Tobi\README.md`
* `<relative path>` a simple relative path '../dir2/./test.txt'
* `<qualified path>` a fully qualified path depending on OS it only contains forward slashes and is cmake's `get_filename_component(result "${input} REAL_PATH)` returns. All symlinks are resolved. It is absolute
* `<unqualified path> ::= <windows path>|<relative path>|<qualified path>` 
* `path(<unqualified path>)-><qualified path>` qualifies a path and returns it.  if path is relative (with no drive letter under windows or no initial / on unix) it will be qualified with the current directory `pwd()`
* `pwd()-> <qualified path>` returns the top of the path stack. relative paths are relative to `pwd()`
* `cd(<unqualified> [--create]) -> <qualified path>` changes the top of the path stack.  returns the `<qualified path>` corresonding to input. if `--create` is specified the directory will be created if it does not exist. if `cd()` is navigated towards a non existing directory and `--create` is not specified it will cause a `FATAL_ERROR`
* `pushd(<unqualified path> [--create]) -> <qualified path>` works the same `cd()` except that it pushes the top of the path stack down instead of replacing it
* `popd()-><qualified path>` removes the top of the path stack and returns the new top path
* `dirs()-> <qualified path>[]` returns all paths in the path stack from bottom to top
* file functions
	- `fread(<unqualified path>)-><string>` returns the contents of the specified file
	- `lines(<unqualified path>)-><string>[]` returns the contents of the specified file in a list of lines
	- `download(<uri> [<target:unqualified path>] [--progress])` downloads the file to target, if target is an existing directory the downloaded filename will be extracted from uri else path is treated as the target filepath
	- `fappend(<unqualified path> <content:string>)->void` appends the specified content to the target file
	- `fwrite(<unqualified path> <content:string>)->void` writes the content to the target file (overwriting it)
	- `parent_dir(<unqualified path>)-><qualified path>` returns the parent directory of the specified path
	- `file_timestamp(<unqualified path>)-><timestampstring>` returns the timestamp string for the specified path yyyy-MM-ddThh:mm:ss
	- `ls([<unqualified path>])-><qualified path>[]` returns files and subfolders of specified path
	- `mkdir(<unqualified path>)-><qualfied path>` creates the specified dir and returns its qualified path
	- `mkdirs(<unqualified path>...)-><qualified path>[]` creates all of the directories specified
	- `mktemp([<unqualified path>])-><qualified path>` creates a temporary directory optionally you can specify where this directory is created (by default it is created in TMP_DIR)
	- `mv(<sourcefile> <targetfile>|[<sourcefile> ...] <existing targetdir>)->void` moves the specifeid path to the specified target if last argument is an existing directory all previous files will be moved there else only two arguments are allowed
	- `paths([<unqualified path> ...])-><qualified path>[]` returns the qualified path for every unqualified path received as input
	- `touch(<unqualified path> [--nocreate])-><qualified path>` touches the specified file creating it if it does not exist. if `--nocreate` is specified the file will not be created if it does not exist. the qualified path for the specified file is returned
	- `home_dir()-><qualified path>` returns the users home directory
	- `home_path(<relative path>)-><qualified path>` returns fully qualified  path relative to the user's home directory
	- ... (more functions are coming whenver they are needed)

# <a name="shell"></a> Shell


## <a name="console"></a> Console Interaction

Since I have been using cmake for what it has not been created (user interaction) I needed to enhance console output and "invent" console input.  using shell magic it became possible for me to read input from the shell during cmake execution.  You can see it in action in the interactive cmake shell `icmake` (start it by running cmake -P icmake.cmake) Also I was missing a way of writing to the shell without appending a linebreak - using `cmake -E echo_append` it was possibly for me to output data without ending the line.  


### Functions

* `read_line()-><string>` prompts the user to input text. waiting for a line break. the result is a string containing the line read from console
* `echo_append([args ...])` appends the specifeid arguments to stdout without a new line at the end
* `echo([args ...])` appends the specified arguments to stdout and adds a new line
 


## <a name="aliases"></a> Aliases

Since I like to provide command line tools based on cmake (using cmake as a cross plattform shell in some sense) I also needed the ability to create aliases in a platform independent way. Even though I have a couple of limitations I have found a good posibillity to do what I want. See the following example of how to create a cross platform way to dowload a file:

```
fwrite("datetimescript.cmake" "
include(\${oocmake_base_dir}/oo-cmake.cmake)
datetime()
ans(dt)
json_print(${dt})
")
path("datetimescript.cmake")
ans(fullpath)
alias_create("my_datetime" "cmake -P \"${fullpath}\"")

```

After executing the above code the current shell will have access to the my_datetime alias and the following call will be possible without any reference to cmake - in this case the cmake command is called of course but `create_alias` can be used to create a alias for any type of executable as bash and windows commandprompts do not differ too much in this respect

```
shell> my_datetime
{
 "yyyy":"2014",
 "MM":"11",
 "dd":"27",
 "hh":"22",
 "mm":"51",
 "ss":"32",
 "ms":"0"
}
```

### Functions and Datatypes

* `alias_create(<alias name> <shell code>)`  - under windows this registers a directory in the users PATH variable. In this directory batch files are created. Under Unix the .bashrc is edited and a alias is inserted.
	- Not implemented yet:
		+ `alias_exists`
		+ `alias_remove`
		+ `alias_list`





# <a name="cmake"></a> CMake Command

Like the version control system I also wrappend cmake itself into an easy to use function called `cmake(...)`  this allows me to start subinstances of cmake

# <a name="tooling"><a> CMake Tooling

To create tools for CMake (wherever something cannot be done with cmake) I created a very simple function called `compile_tool(<name> <src>)`

This function does the following tasks

* creates a cmake project with CMakeLists file and a single executable target the target has a single source file (whatever you put in `<src>`)
* compiles this tool (the tool may only use standard headers currently)
* caches the compiled tool so that it is not recompiled unless src changes
* creates a wrapper function in cmake called `<name>` which evaluates the cmake code that the command outputs
* arguments passed to wrapper `<name>` are passed along as command line args for the main method.

*note*: this will change in the future as it is a very naive implementation.


## Example

Because cmake does not support getting the current time in milliseconds since the epoch the need arose for me to compile custom code. This code is the example for using the `compile_tool(..)` function.

```
## returns the number of milliseconds since epoch
function(millis)
  # initializer function pattern - because compile_tool
  # redefines the millis function this code is only executed once
  compile_tool(
  	# first argument: the name of the tool 
  	# and the function name to be defined  	
  	millis 
  	# second argument: the source code to compile
  	# with default compiler/generator under you system  	
  	"
    #include <iostream>
    #include <chrono>
    int main(int argc, const char ** argv){
     // use chrono to get the current time in milliseconds
     auto now = std::chrono::system_clock::now();
     auto duration = now.time_since_epoch();
     auto millis = std::chrono::duration_cast<std::chrono::milliseconds>(duration).count();
     // return cmake code which is to be evaluated by command wrapper
     // set_ans will let the eval function return the specified value
     std::cout<< \"set_ans(\" << millis << \")\";
     return 0;
    }
    "
    )
  ## compile_tool has either failed or succesfully defined the function
  ## wrapper called millis
  millis(${ARGN})
  return_ans()
endfunction()

# now you can use millis
millis()
ans(ms)
message("time since epoch in milliseconds: ${ms}")
```


# <a name="userdata"><a> User Data

User Data is usefull for reading and writing configuration per user.  It is available for all cmake execution and can be undestood as an extra variable scope. It however allows maps which help structure data more clearly.  User Data is stored in the users home directory (see `home_dir`) where a folder called `.oocmake` inside are files in a quickmap format which can be edited in an editor of choice besides being managed by the following functions.  User Data is always read and persisted directly (which is slower but makes the system more consistent)

## Functions and Datatypes

* `<identifier>`  a string
* `user_data_get(<id:<identifier>> [<nav:<navigation expression>>|"."|""]):<any>` returns the user data for the specified identifier, if a navigation expression is specified the userdata map will be navigated to the specified map path and the data is returned (or null if the data does not exist). 
* `user_data_set(<id:<identifier>> <<nav:<navigation expression>>|"."|""|> [<data:any ...>]):<qualified path>` sets the user data identified by id and navigated to by  navigation
* `user_data_dir():<qualified path>` returns the path where the userdata is stored: `$HOME_DIR/.oocmake`
* `user_data_ids():<identifier ...>` returns a set of identifiers where user data was stored
* `user_data_clear(<"--all"^<id:<identifier>>>):<void>` if `--all` is specified all user data is removed. (use with caution) else only the user data identified by `<id>` is removed
* `user_data_read(<id:<identifier>>):<any>` deserializes the user data identified by id and returns it (`user_data_get` and `user_data_set` are based on this function)
* `user_data_write(<id:<identifier>> [<data:<any> ...>]):<qualified path>` serializes and persists the specified data and associates it with `<id>`
* `user_data_path(<id:<identifier>> ):<qualified path>` returns the filename under which the user data identified by `<id>` is located

## Example

```

## store user data during cmake script execution/configuration/generation steps
## this call creates and stores data in the users home directory/.oocmake
user_data_set(myuserdata configoptions.configvalue "my value" 34)


## any other file executed afterwards
user_data_get(myuserdata)
ans(res)

json_print(${res}) 

## outputs the folloing
# {
#	  configoptions:{
#	    configvalue:["my value",34]
#   }
# }

```

# <a name="process_management"><a> Process Management

When working with large applications in oocmake it becomes necessary to work in parallel.  I implemented a platform independent controll mechanism for spawning killing and waiting for processes.  


## Functions and Datatypes

* `<process id> ::= <string>` a unspecified systemwide unique string which identifies a process
* `<process start info> ::= { }`  
* `process_spawn():<process info>`
* `process_kill(<id:<process id>>)`
* `process_list()`
* `process_status()`


using cmd's start and bash's ampersand operator it should be possible to fork off processes.

# <a name="string_functions"></a> String Functions

# <a name="lists"></a> Lists Functions

# <a name="shell"></a> Shell Functions

# <a name="expr"></a> Expression Syntax

# <a name="implementation_notes"></a> Implementation Notes


## Passing By Ref

Passing a variable to a function can be done by value and or by reference.
```
function(byval var)
	message("${var}")
endfunction()

function(byref ref)
	message("${${ref}}")
endfunction()

set(some_val 3)

byval(${some_val}) # prints 3
byref(some_val) # prints 3

```

Passing 'by ref' is possible because a function inherits its parent scope. The problem with passing by ref is the following:

```
function(byref ref)
	set(val 1)
	message("${${ref}} ${val}")
endfunction()

set(val 2)
byref(val) #expected to print "2 1" but actually prints "2 2"
```

The workaround I chose was to mangle all variable names starting with a `__<function_name>_<varname>`  (however special care has to be taken with recursive functions). This should stop accidental namespace collisions:

```
function(byref __byref_ref)
	set(__byref_val 1)
	message("${${__byref_ref}} ${__byref_val}")
endfunction()

```

So If you read some of the functions and see very strange variable names this is the explanation.




... more coming soon
