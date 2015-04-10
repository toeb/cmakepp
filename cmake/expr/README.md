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


## more examples...

```

## <a name="expr_functions"></a> Functions and Datatypes

I provide the following functions for you to interact with `expr`.  



* [expr](#expr)
* [expr_eval](#expr_eval)
* [expr_parse](#expr_parse)

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
    expr("\"\"")    => ``
    expr("\"hello\"")   => `hello`
    expr("\"\\' single quote\"")    => `' single quote`
    expr"\"\\\" double quote\"" => `" double quote`
    expr("\\ backslash")    => `\ backslash`

<double quoted string> ::= "'" <quoted string content> "'"
    expr("''")    =>  ``
    expr('')    =>  ``
    expr("'hello'")   =>  `hello`
    expr('hello')   =>  `hello`
    expr("'\\' single quote'")    =>  `' single quote`
    expr("'\\\" double quote'")
    expr('\\ backslash')
    expr('\" double quote')

<unquoted string> ::= 
    ...
<separated string> ::= 
    ""
    "hello world"
    ...

<string> ::= <double quoted string> | <single quoted string> | <unquoted string> | <separated string>

## every literal is a const string 
## some unquoted strings have a special meaning
## quoted strings are always strings even if their content matches one
## of the specialized definitions
<number> ::= /0|[1-9][0-9]*/
    number
        0
        1
        912930
    NOT number:
        01
        "'1'" 
        "\"1\""

<bool> ::= "true" | "false"
    bool
        true
        false
    NOT bool
        "'true'"
        "\"false\""

<null> ::= "null"
    null
        null
    NOT null
        "'null'"

<literal> ::= <string>|<number>|<bool>|<null>
    valid literal
        "hello world"
        123
        "'123'"
        true
        null
        ""
        abc




<value> ::= <paren>|<value dereference>|<value reference>|<ellipsis>|<literal>|<interpolation>|<bind call>|<call>|<list>|<object>|<scope variable>|<indexation>|<navigation>

## an interpolation combines multiple values into a single value
<interpolation> ::= <value> * 
    expr("a" "b" "c") => `abc`

<expression> ::= <assign>|<value> 

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