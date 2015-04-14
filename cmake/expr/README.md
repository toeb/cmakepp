# CMake Expression Syntax

_This Document is currently just a draft_

## <a name="expr_motivation"></a> Motivation


CMake's syntax is not sexy. It does not allow the developer rudimentary constructs which almost all other languages have.  But because CMake's language is astonishingly flexible I was able to create a lexer and parser and interpreter for a custom 100 % compatible syntax which (once "JIT compiled") is also fast.


## <a name="expr_example"></a> Example

The easiest way to introduce the new syntax and its usefulness is by example. So here it is (Note that these example are actually executed during the generation of this document using my cmake template engine ([link](#)) so the result displayed is actually computed).

```cmake
# values
## number
expr(1) # => `1` 

## bool
expr(true) # => `true`
expr(false) # => `false`

## null
expr(null) # => ``

## single quoted string
expr("'hello world'") # => `hello world` 
expr("'null'") # => `null` 

## double quoted string
expr("\"hello world\"") # => `hello world`

## separated string (a string which is a single argument)
expr("hello world") # => `hello world` 

## unquoted
expr(hello)  # => `hello`

## list
expr([1,2,3])  # => `1;2;3`

## object 
expr({first_name:Tobias, 'last_name': "Becker" })  # => {"first_name":"Tobias","last_name":"Becker"}

## complex value
expr({value:[1,{a:2,b:{c:[3,4,5],d:2}},{}]})  # => {"value":[1,{"a":2,"b":{"c":[3,4,5],"d":2}},{}]}

## concatenation 
expr(hello world 1 null 2 'null' 3) # => `helloworld12null3`


# scope variables
## variable
set(my_var "hello world")
expr($my_var) # => `hello world`

## variable scope variable 
set(my_var "hello world")
set(var_name my_var)
expr($($var_name))  # => `hello world`

## assign scope variable
expr($a = 1)
assert("${a}" EQUAL 1)  # => `1`

# function
## test function
function(my_add lhs rhs)
    math(EXPR sum "${lhs} + ${rhs}")
    return("${sum}")
endfunction()
## call normal cmake function
expr(my_add(1,2))  # => `3`

## use function invocation as argument (`f(g(x))`)
expr(my_add(my_add(my_add(1,2),3),4)) # => `10`
 
## use bind call which inserts the left hand value into a function as the first parameter 
expr("hello there this is my new title"::string_to_title()) # => `Hello There This Is My New Title`

## enabling cmakepp expressions for the current function scope
function(my_test_function) 
    ## here expressions ARE NOT evaluated yet
    set(result "unevaluated $[hello world]")
    ## this call causes cmakepp expressions to be evaluated for
    ## the rest of the current function body
    cmakepp_enable_expressions(${CMAKE_CURRENT_LIST_LINE})
    ## here expressions ARE being evaluated
    set(result "${result} evaluated: $[hello world]")
    return(${result})
endfunction()
my_test_function() # => `unevaluated $[hello world] evaluated: helloworld`

## more examples...

```

## <a name="expr_functions"></a> Functions and Datatypes

I provide the following functions for you to interact with `expr`.  



* [expr](#expr)
* [expr_eval](#expr_eval)
* [expr_parse](#expr_parse)
* [cmakepp_expr_compile](#cmakepp_expr_compile)
* [cmakepp_compile_file](#cmakepp_compile_file)
* [cmakepp_eval](#cmakepp_eval)
* [cmakepp_include](#cmakepp_include)
* [cmakepp_enable_expressions](#cmakepp_enable_expressions)

## <a name="expr"></a> `expr`

 `(<expression>)-><any>`

 parses, compiles and evaluates the specified expression. The compilation result
 is cached (per cmake run)





## <a name="expr_eval"></a> `expr_eval`

 `(<expression type> <arguments:<any>...> <expression>)-><any> 

 evaluets the specified expression using as the type of expression 
 specified.  also passes allong arguments to the parser




## <a name="expr_parse"></a> `expr_parse`

 `(<expression type> <arguments:<any...>> <expression>)-><expr ast>`


 parsers and caches the expression. returns the AST for the specified
 expression.  See `ast_new`




## <a name="cmakepp_expr_compile"></a> `cmakepp_expr_compile`

 `(<cmakepp code>)-><cmake code>`

 `<cmakepp code> ::= superset of cmake code with added expression syntax in $[...] `
 
 compiles the specified cmakepp code to pure cmake code
 replacing `$[...]` with the result of the cmakepp expression syntax (see `expr(...)`)
 e.g.
 ```
 function(my_name)
  return("tobi")
 endfunction()
  message("hello $[my_name()]::string_to_upper()") # prints `hello TOBI`
 ```





## <a name="cmakepp_compile_file"></a> `cmakepp_compile_file`

 `(<cmakepp code file>)-><cmake code file>`

 compiles the specified source file to enable expressions
 the target file can be specified. by default a temporary file is created
 todo:  cache result




## <a name="cmakepp_eval"></a> `cmakepp_eval`

 `(<cmakepp code>)-><any>`

 evaluates the specified cmakepp code




## <a name="cmakepp_include"></a> `cmakepp_include`

 `()->`

 includes the specified cmakepp file (compiling it)




## <a name="cmakepp_enable_expressions"></a> `cmakepp_enable_expressions`

 `(${CMAKE_CURRENT_LIST_LINE})-><any>`

 you need to pass `${CMAKE_CURRENT_LIST_LINE}` for this to work

 this macro enables all expressions in the current scope
 it will only work in a CMake file scioe or inside a cmake function scope.
 You CANNOT use it in a loop, if statement, macro etc (everything that has a begin/end)
 Every expression inside that scope (and its subscopes) will be evaluated.  

 **Implementation Note**:
 This is achieved by parsing the while cmake file (and thus potentially takes very long)
 Afterwards the line which you pass as an argument is used to find the location of this macro
 every argument for every following expression in the current code scope is scanned for
 `$[...]` brackets which are in turn lexed,parsed and compiled (see `expr()`) and injected
 into the code which is in turn included






## <a name="expr_definition"></a> The Expression Language Definition

I mixed several constructs and concepts from different languages which I like - the syntax should be familiar for someone who knows JavaScript and C++.  I am not a professional language designer so some decisions might seem strange however I have tested everything thouroughly.

The examples are not cmake strings. They need to be escaped again in some cases
```
## the forbidden chars are used by the tokenizer and using them will cause the world to explode. They are all valid ASCII codes < 32 and > 0 
<forbidden char> ::=  SOH | NAK | US | STX | ETX | GS | FS | SO  
<escapeable char> :: = "\" """ "'"  
<free char> ::= <ascii char>  /  <forbidden char> / <escapablechar> 
<escaped char> 
<quoted string content> ::= <<char>|"\" <escaped char>>* 

## strings 
<double quoted string> ::= """ <quoted string content> """
    expr("\"\"") # => ``
    expr("\"hello\"") # => `hello`
    expr("\"\\' single quote\"") # => `' single quote`
    expr("\"\\\" double quote\"") # => `" double quote`
    expr("\"\\ backslash\"") # => `\ backslash`

<single quoted string> ::= "'" <quoted string content> "'"
    expr("''") # => ``
    expr('') # => ``
    expr("'hello'") # => `hello`
    expr('hello') # => `hello`
    expr("'hello world'") # => `hello world`
    expr("'\\' single quote'") # => `' single quote`
    expr("'\\\" double quote'") # => `" double quote`
    expr("'\\\\ backslash'") # => `\\ backslash`

<unquoted string> ::= 
    expr(hello) # => `hello`

<separated string> ::= 
    expr("") # => ``
    expr("hello world") # => `hello world`
    

<string> ::= <double quoted string> | <single quoted string> | <unquoted string> | <separated string>

## every literal is a const string 
## some unquoted strings have a special meaning
## quoted strings are always strings even if their content matches one
## of the specialized definitions
<number> ::= /0|[1-9][0-9]*/
    number
        expr(0) # => `0`
        expr(1) # => `1`
        expr(912930) # => `912930`
    NOT number:
        expr(01) # => `01`
        expr('1') # => `1`
        expr("\"1\"") # => `1`

<bool> ::= "true" | "false"
    bool
        expr(true) # => `true`
        expr(false) # => `false`
    NOT bool
        expr('true') # => `true`
        expr(\"false\") # => `false`

<null> ::= "null"
    null
        expr(null) # => ``
    NOT null
        expr('null') # => `null`

<literal> ::= <string>|<number>|<bool>|<null>
    valid literal
        expr("hello world") # => `hello world`
        expr(123) # => `123`
        expr('123') # => `123`
        expr(true) # => `true`
        expr(null) # => ``
        expr("") # => ``
        expr(abc) # => `abc`

<list> ::= "[" <empty> | (<value> ",")* <value> "]"
    expr("[1,2,3,4]") # => `1;2;3;4`
    expr("[1]") # => `1`
    expr("[string_to_title('hello world'), 'goodbye world'::string_to_title()]") # => `Hello World;Goodbye World`

<key value> ::= <value>:<value>
<object property> ::= <key value> | <value>
<object> ::= "{" <empty> | (<object property> ",")* <object property> "}"
    expr({}) # => {} 
    expr({a:b}) # => {"a":"b"} 
    expr({a: ("hello world"::string_to_title())}) # => {"a":"Hello World"} 

<paren> ::= "(" <value> ")"
## ellipsis are treated differently in many situation
## if used in a function parameter the arguments will be spread out
## if used in a navigation or indexation expression the navigation or
## indexation applied to every element in value
<ellipsis> ::= <value> "..." 

## if lvalue is <null> it is set to the default value (the default default value is a address/map)
<default value> ::= <lvalue> "!" | "!" <value>  # specifying the default value

<value> ::= <paren> |
            | <value dereference>
            | <value reference>
            | <ellipsis>
            | <literal>
            | <interpolation>
            | <bind call>
            | <call>
            | <list>
            | <object>
            | <scope variable>
            | <indexation>
            | <navigation>
            | <paren>
            | <default value>

## a parameter can be a value or the returnvalue operator "$"
## if the return value operator is specified the output of that parameter
## is treated as the result of the function call 
## this is usefull for using function which do not adhere to the
## return value convention. If used multiple times inside a call
## the results are accumulated.   
<parameter> ::= <value> | "$" 

<parameters> ::= "(" <empty> | (<parameter> "," )* <parameter>  ")"

<normal call> ::= <value> <parameters>
    expr(string_to_title("hello world")) # => `Hello World` 
    expr("eval_math('3 + 4')") # => `7`

## bind call binds the left hand value as the first parameter of the function
<bind call> ::=  <value> "::" <value> <parameter>  
    expr("hello world"::string_to_title()) # => `Hello World` 

<call> ::= <normal call> | <bind call>

<scope variable> ::= "$" <literal> 
    set(my_var hello!) 
    expr($my_var) # => `hello!` 


<index> ::= "-"? <number> | "$" | "n"
<increment> ::= "-"? <number>
<range> ::= <empty> | <index> | <index> ":" <index> | <index> ":" <index> : <increment>

<indexation parameter> ::= <range> | <value>
<indexation parameters> ::= (<indexation parameter> ",")* <indexation parameter>
<indexation> ::= <value>"[" <indexation parameters> "]"
    expr("{a:1,b:2}['a','b']") # => `1;2` 
    expr("[{a:1,b:2},{a:3,b:4}]...['a','b']") # => `1;3;2;4`

<lvalue> ::= <scope variable> | <navigation> | <indexation>


<assign> ::= <lvalue> "=" <value>
    ## sets the scope variable my_value to 1
    expr($my_value = 1)
    expr($my_value) # => `1` 
    ## coerces the scope value my_other_value to be an object
    #expr($my_other_value!.a!.b = 123)
    #expr($my_other_value) # => `` 


<expression> ::= <assign> | <value> 

```



## Performance

Here is some performance data for the cmake expression syntax


Expression | Token Count | Ast Nodes | Compile Time | Cached Compile Time |  Execution Time | Compile Statements
`$the_object.e[0,1]...['a']` | 15 | 9 | 420 ms | 5 ms | 22



## Still Open

* derefernce 
* address of
* out value
    - `$` as result indicator
    - 
* lvalue range
* lvalue range assign
* lvalue range assign ellipsis
* lambda
* statements
* closures
* force path existance
* operators
    - *math* CMake needs a basic math system to be inplace `math(EXPR)` is really, really bad. 
        + `+`
        + `-`
        + `*`
        + `/`
        + `%`
    - string 
    - any
        + `??` null coalescing operator
    





## Future Work

When the syntax is complete and this feature works well the next step is to incorporate it into CMake using C code.  This will make everything much, much faster and will get rid of those hideous generator expressions.  Maybe even the whole cmake script language itself.