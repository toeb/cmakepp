# Templating 



While working on the documentation of `cmakepp` I grew wary of always doubling the documentation - one in the source code and a mirror in the `README.md`.  Also I was frustrated when I refactored and renamed functions or changed signatures which is not uncommon - especially when working on a new feature. So I needed a tool which could generate the documentation by copying the comment header and the function signature from my `CMake` files.  

While the comment/signature/cmake script parsing is done by `cmake_script_parse(...)` and is another subject, I still stood before the problem of combining all the information into useful documentation.  I especially did not want a too special solution which does not allow for special cases / different formatting.  So I took inspiration from some of existing template engines like `razor` or `asp` and managed to implement the core logic in less than 60 lines of `CMake` code.

While my original thought was only 'how is the best way to generate markdown' I soon realized that This kind of templating would allow for quite some more domains to be served.  For Example generating `C++` source code (i.e. data structures) - any kind of text based format could easily be generated.  

`CMake` itself allows you to do something not quite similar.  You can use the `string(CONFIGURE)` and `file(CONFIGURE)` functions to replace `@vars@` within text with values that you have specified.  This howeverwill never allow you to generate complex structures as simple as an inline `foreach()` loop.  

When I was finished with implementing my solution I noticed I had a far more mighty tool at hand than I anticipated:  I could let the functions which I was documenting run and add the result to my documentation.  For Example see the comments for [ls](#) and the resulting [README.md](#)




## Template Process

The template process is as follows:
```                            
                                                       |cmake scope|
                                                            vvv             
(|file| =read=>) |string| =template_compile=> |cmake code| =eval=> |string| (=write=> |file|)
```

## Template Syntax

The template syntax is quite easy:
* `<%` `%>` encloses cmake code
* `<%%` and `%%>` escape `<%` and `%>` resp.
* `<%=` runs the function specified if possible (only single line function calls allowed) or formats the following string using the `format()` function (allows things like `<%="${var} {format.expression[3].navigation.key}%>`) 
    * single line function calls are `func(.....)` but not `func(... \n ....)` 
* shorthands
    * `@<cmake function call>` is replaced with `<%= <cmake function call> %>`
    * `@<navigation expression>` is replaced with `<%= {<navigation expression>}%>`


## Example

This example takes an template input file and creates output using some given data.  You can also check out my [Samples Repository](#samples) for templating.

*Input file - mytemplate.in*
```
Hello this is <%={user.first_name}%>,

I am writing you from within a template file!  Here are some things I like:
<% foreach(thing ${things}) %>* The Thing: <%={thing.name}%> - <%={thing.description}%>
<% endforeach() %>

Thanks for Reading! Write me at <%={user.email}%>
(path of this file: <%=${template_path}%>)
```

*CMake*
```cmake
## create a user object
data("{
    first_name:'Tobias',
    last_name:'Becker',
    email:'toeb@thetoeb.de'
}")
ans(user)

## create a list of things
data("[
    {
        name:'Swimming',
        decsription:'humanoid aquatic propulsion'
    },
    {
        name:'Programming',
        decsription:'converting ideas to instructions'
    },
    {
        name:'Squash',
        decsription:'destroying your body while chasing a ball'
    }
]")
ans(things)

## now run the template file

template_run_file("mytemplate.in")
ans(generated_content)

message("${generated_content}")
```

*stdout*
```cmake
Hello this is Tobias,

I am writing you from within a template file!  Here are some things I like:
* The Thing: Swimming - humanoid aquatic propulsion
* The Thing: Programming - converting ideas to instructions
* The Thing: Squash - destroying your body while chasing a ball


Thanks for Reading! Write me at toeb@thetoeb.de
(path of this file: D:/projects/cmakepp/cmake/templating/README.md.in)
```

## Implementation

The implemenation is  straightforward: Using `CMake`'s regex functionality I split the input template into `code fragment` s and `literal fragment`s  source fragments are such which start with `<%` and end with `%>`. Out of these fragments I generate a `cmake code` listing which can be executed. This is done by appending `code fragments` directly and appending a `template_out(<literal fragment>)` for every `literal fragment`. The template itself works by creating an accumulator variable which can be appended to via `template_out`  .

Some more transformations are performed but the gist ist captured in this description.

*Example*

template string
```
Hello <%={user.name}%>, 
<%foreach(i RANGE 1 3)%>* <%=${i}%>
<%endforeach()%>
```

result of `template_compile` **Note**  *the strings seem may seem strange. That is because they are `cmake_escape`d.*  
```cmake
template_begin()
template_out("Hello\ ")
template_out_format({user.name})
template_out(",\ \n")
foreach(i RANGE 1 3)
template_out("*\ ")
template_out_format(${i})
template_out("\n")
endforeach()
 template_end()
```




## Caveats

There is  one major caveat at the moment.  Files larger than `500 kB` lead to memory exhaustion in cmake. I know how to alleviate this problem but I will not until it is necessary.


### Function List


* [template_compile](#template_compile)
* [template_compile_file](#template_compile_file)
* [template_execute](#template_execute)
* [template_run](#template_run)
* [template_run_file](#template_run_file)
* [template_begin](#template_begin)
* [template_end](#template_end)
* [template_guard](#template_guard)
* [template_out](#template_out)
* [template_output_stream](#template_output_stream)
* [template_out_format](#template_out_format)
* [template_out_json](#template_out_json)

### Function Descriptions

## <a name="template_compile"></a> `template_compile`





## <a name="template_compile_file"></a> `template_compile_file`





## <a name="template_execute"></a> `template_execute`





## <a name="template_run"></a> `template_run`





## <a name="template_run_file"></a> `template_run_file`





## <a name="template_begin"></a> `template_begin`





## <a name="template_end"></a> `template_end`





## <a name="template_guard"></a> `template_guard`





## <a name="template_out"></a> `template_out`





## <a name="template_output_stream"></a> `template_output_stream`





## <a name="template_out_format"></a> `template_out_format`





## <a name="template_out_json"></a> `template_out_json`







