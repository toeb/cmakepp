# Reference Values


CMake has a couple of scopes every file has its own scope, every function has its own scope and you can only have write access to your `PARENT_SCOPE`.  So I searched for  simpler way to pass data throughout all scopes.  My solution is to use CMake's `get_property` and `set_property` functions.  They allow me to store and retrieve data in the `GLOBAL` scope - which is unique per execution of CMake. It is my RAM for cmake - It is cleared after the programm shuts down.

I wrapped the get_property and set_property commands in these shorter and simple functions:


### Function List


* [ref_append](#ref_append)
* [ref_append_string](#ref_append_string)
* [ref_delete](#ref_delete)
* [ref_get](#ref_get)
* [ref_gettype](#ref_gettype)
* [ref_istype](#ref_istype)
* [ref_isvalid](#ref_isvalid)
* [ref_new](#ref_new)
* [ref_peek_back](#ref_peek_back)
* [ref_peek_front](#ref_peek_front)
* [ref_pop_back](#ref_pop_back)
* [ref_pop_front](#ref_pop_front)
* [ref_prepend](#ref_prepend)
* [ref_print](#ref_print)
* [ref_push_back](#ref_push_back)
* [ref_push_front](#ref_push_front)
* [ref_set](#ref_set)
* [ref_setnew](#ref_setnew)

### Function Descriptions

## <a name="ref_append"></a> `ref_append`





## <a name="ref_append_string"></a> `ref_append_string`





## <a name="ref_delete"></a> `ref_delete`





## <a name="ref_get"></a> `ref_get`





## <a name="ref_gettype"></a> `ref_gettype`





## <a name="ref_istype"></a> `ref_istype`





## <a name="ref_isvalid"></a> `ref_isvalid`





## <a name="ref_new"></a> `ref_new`





## <a name="ref_peek_back"></a> `ref_peek_back`





## <a name="ref_peek_front"></a> `ref_peek_front`





## <a name="ref_pop_back"></a> `ref_pop_back`





## <a name="ref_pop_front"></a> `ref_pop_front`





## <a name="ref_prepend"></a> `ref_prepend`





## <a name="ref_print"></a> `ref_print`





## <a name="ref_push_back"></a> `ref_push_back`





## <a name="ref_push_front"></a> `ref_push_front`





## <a name="ref_set"></a> `ref_set`





## <a name="ref_setnew"></a> `ref_setnew`









```
ref_new()   # returns a unique refernce (you can also choose any string)
ref_set(ref [args ...]) # sets the reference to the list of arguments
ref_get(ref) # returns the data stored in <ref> 

# some more specialized functions
# which might be faster in special cases
ref_setnew([args ...])    # creates, returns a <ref> which is set to <args>
ref_print(<ref>)      # prints the ref
ref_isvalid(<ref>)      # returns true iff the ref is valid
ref_istype(<ref> <type>)  # returns true iff ref is type
ref_gettype(<ref>)      # returns the (if any) of the ref       
ref_delete(<ref>)     # later: frees the specified ref
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
