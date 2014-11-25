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
	* [interactive cmake console](#icmake) (icmake.bat, icmake.sh)
	* [eval](#eval) - evaluates cmake code and is the basis of many advanced features
	* [shell](#shell)
		* readline - allows user input from the keyboard
		* "plattfrom independent" shell execution using shell() 
		* directory and file functions (like bash)
			* cd(), pushd(), popd(), mkdir() pwd(), touch(), ls(), fappend(), fwrite(),...
			* path(possbilyRelativePath) -> gets the absolute path 
	* debugging
		* some convenience functions
		* breakpoint() - stops execution at specified location and allows inspection of cmake variables, execution of code (if -DDEBUG_CMAKE was specified in command line)
	* vcs
		* hg()... hg(init), hg(clone <url>), ...
		* git()... git(init), git(clone <url>),... shorthand for executing git in any directory
	* [string functions](#string functions) 
		* string_slice
		* string_splice
		* Semantic Versions ([semver](#semver))
			- normalizing 
			- convert to object
			- semver constraints
			-
		* ...
	* [lists](#lists) -extension to cmake list() functionaly
		* peeking, popping, sorting, map, fold, predicates(any,all,contains,...)
	* [maps](#maps) - basic map functions and utility functions (nested data structures for cmake)
		* get/set/append/remove operations
		* extended operations
		* nav - navigate through a path of maps, allows getting and setting e.g. nav(res = map1.prop1.prop12), nav(resultmap.prop.otherprop = res)....
		* serialization
			* [json](#json)
			* [quickmap format](#quickmap) (native to cmake)
		* invert
		* import
		* capture
		* extract
		* omit
		* partial
		* pick
		* values
		* algorithms
			* depth first serach
			* breadth first search
			* graph search
			* ...
		* ...
	* [expression syntax](#expr).
			* obj("{id:1,prop:{hello:3, other:[1,2,3,4]}}") -> creates the specified object
	* functions
		* [returning values](#return)
		* define dynamic functions (without cluttering the namespace)
		* call functions dynamically (basically allowing ${functionName}(arg1 arg2 ...) `call(${functionName}(arg1 arg2 ...))`
		* set a variable to the result of functions `rcall(result = somefunction())`
		* lambda functions (a shorthand syntax for defining inline functions.  `(var1,var2)-> do_somthing($var1); do_something_else($var2)` 
		* import functions (from files, from string, ...)
	* [objects](#objects) - object oriented programming with prototypical inheritance, member functions
	* events
		* you can globally register and call events 
	* targets
		* [access to a list of all defined targets](#target_list)
		* easier access to target properties
		* 
	* other things like web queries, packing and unpacking,...
	* [implementation notes](#implementation_notes)
NOTE: the list is incomplete
# <a name="icmake"></a>Interactive CMake Shell

If you want to learn try or learn cmake and `oocmake` you can use the interactive cmake shell by launching `icmake.bat` or `icmake.sh` which gives you a prompt with the all functions available in `oocmake`.

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
Therfore I overwrote all target adding functions `add_library`, `add_executable`, `add_custom_target`, `add_test`, ... which now register the name of the target globally in a list. You can access this list by using the function `target_list()` which returns the list of known target names .  Note that only targets defined before the `target_list()`  call are known.  

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
* 


# <a name="eval"></a> Eval

# <a name="string functions"></a> String Functions

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
