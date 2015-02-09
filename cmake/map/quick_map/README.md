## <a name="quickmap"></a>Quick Map Syntax




To quickly define a map in cmake I introduce the quick map syntax which revolves around these 5 functions and is quite intuitive to understand:
```
map([key]) # creates, returns a new map (and parent map at <key> to the new map) 
key(<key>)  # sets the current key
val([arg ...])  # sets the value at current map[current key] to <args>
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
    kv(name cmakepp)
    kv(url https://github.org/toeb/cmakepp)
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
      "name":"cmakepp",
      "url":"https://github.org/toeb/cmakepp"
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


### Function List


* [end](#end)
* [key](#key)
* [kv](#kv)
* [map](#map)
* [ref](#ref)
* [val](#val)
* [var](#var)

### Function Descriptions

## <a name="end"></a> `end`





## <a name="key"></a> `key`





## <a name="kv"></a> `kv`





## <a name="map"></a> `map`





## <a name="ref"></a> `ref`

 ref() -> <address> 
 
 begins a new reference value and returns its address
 ref needs to be ended via end() call




## <a name="val"></a> `val`





## <a name="var"></a> `var`

 captures a list of variable as a key value pair






