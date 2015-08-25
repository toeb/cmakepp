# `CMake` Script Parsing, Token Manipulation, Reflection

CMake's language lends itself to be parsed and tokenized easily. The [specification](http://www.cmake.org/cmake/help/v3.0/manual/cmake-language.7.html#syntax) shows which tokens are available.  Since the functional blocks of CMake only are `command_invocations`s the language's structure very simple.  

My parser takes any cmake code (the version of code supported is still to be determined as for example bracket arguments are not supported but bracket comments are) and creates a list of tokens.  These tokens are also part of a linked list.  This linked list can be used to modify token values or add new tokens which in essence allows reflection and manipulation of the source code.

```
<cmake token>: {
    type:<token type>
    value: <string>
    literal_value: <string>
    line: <uint>
    column: <uint>
    length: <uint>
    *next :<cmake token>
    *previous: <cmake token>
}
<nesting token> ::= <cmake token> v {
    type: "nesting",
    value: "(",
    literal_value: "(",
    end: <nesting end token>
}
<nesting end token> ::= <cmake token> v {
    type: "nesting_end",
    value: ")",
    literal_value: ")",
    begin: <nesting begin token>
}
```






## Function List


* [cmake_tokens](#cmake_tokens)
* [cmake_tokens_parse](#cmake_tokens_parse)
* [cmake_token_range](#cmake_token_range)
* [cmake_token_advance](#cmake_token_advance)
* [cmake_token_go_back](#cmake_token_go_back)
* [cmake_token_range_filter](#cmake_token_range_filter)
* [cmake_token_range_filter_values](#cmake_token_range_filter_values)
* [cmake_token_range_insert](#cmake_token_range_insert)
* [cmake_token_range_remove](#cmake_token_range_remove)
* [cmake_token_range_replace](#cmake_token_range_replace)
* [cmake_token_range_serialize](#cmake_token_range_serialize)
* [cmake_token_range_to_list](#cmake_token_range_to_list)
* [cmake_invocation_filter_token_range](#cmake_invocation_filter_token_range)
* [cmake_invocation_get_arguments_range](#cmake_invocation_get_arguments_range)
* [cmake_invocation_remove](#cmake_invocation_remove)
* [cmake_invocation_token_set_arguments](#cmake_invocation_token_set_arguments) 

## Function Descriptions

## <a name="cmake_tokens"></a> `cmake_tokens`





## <a name="cmake_tokens_parse"></a> `cmake_tokens_parse`





## <a name="cmake_token_range"></a> `cmake_token_range`





## <a name="cmake_token_advance"></a> `cmake_token_advance`





## <a name="cmake_token_go_back"></a> `cmake_token_go_back`





## <a name="cmake_token_range_filter"></a> `cmake_token_range_filter`





## <a name="cmake_token_range_filter_values"></a> `cmake_token_range_filter_values`





## <a name="cmake_token_range_insert"></a> `cmake_token_range_insert`





## <a name="cmake_token_range_remove"></a> `cmake_token_range_remove`





## <a name="cmake_token_range_replace"></a> `cmake_token_range_replace`





## <a name="cmake_token_range_serialize"></a> `cmake_token_range_serialize`





## <a name="cmake_token_range_to_list"></a> `cmake_token_range_to_list`





## <a name="cmake_invocation_filter_token_range"></a> `cmake_invocation_filter_token_range`





## <a name="cmake_invocation_get_arguments_range"></a> `cmake_invocation_get_arguments_range`





## <a name="cmake_invocation_remove"></a> `cmake_invocation_remove`





## <a name="cmake_invocation_token_set_arguments"></a> `cmake_invocation_token_set_arguments`





 


