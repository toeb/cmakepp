# Navigation Functions



After creating `maps` and `objects` it was only prudent to create something that enables ease of use for the user.

Only using `map_set` and `map_get` like functions is very frustrating especially if the depth of an object graph is more than one. consider:
```cmake
map_tryget(${obj} a)
ans(val_a)
if(val_a)
    map_tryget(${val_a} b)
    ans(val_b)
    ...
endif()
```


So I created the `assign` function which brings great comfort to navigating a object graph.  It supports assignment to and from any navigation expression. navigation expressions support property navigation and range based list access.

Here are some **Examples**:



## Function List


* [assign](#assign)
* [get](#get)
* [map_navigate](#map_navigate)
* [map_navigate_set](#map_navigate_set)
* [map_navigate_set_if_missing](#map_navigate_set_if_missing)
* [nav](#nav)
* [navigation_expression_parse](#navigation_expression_parse)
* [ref_keys](#ref_keys)
* [ref_nav_create_path](#ref_nav_create_path)
* [ref_nav_get](#ref_nav_get)
* [ref_nav_set](#ref_nav_set)
* [ref_prop_get](#ref_prop_get)
* [ref_prop_set](#ref_prop_set)

## Function Descriptions

## <a name="assign"></a> `assign`





## <a name="get"></a> `get`





## <a name="map_navigate"></a> `map_navigate`

navigates a map structure
 use '.' and '[]' operators to select next element in map
 e.g.  map_navigate(<map_ref> res "propa.propb[3].probc[3][4].propd")




## <a name="map_navigate_set"></a> `map_navigate_set`





## <a name="map_navigate_set_if_missing"></a> `map_navigate_set_if_missing`





## <a name="nav"></a> `nav`

 a convenience function for navigating maps
 nav(a.b.c) -> returns memver c of member b of map a
 nav(a.b.c 3) ->sets member c of member b of map a to 3 (creating any missing maps along the way)
 nav(a.b.c = d.e.f) -> assignes the value of d.e.f to a.b.c
 nav(a.b.c += d.e) adds the value of d.e to the value of a.b.c
 nav(a.b.c -= d.e) removes the value of d.e from a.b.c
 nav(a.b.c FORMAT "{d.e}@{d.f}") formats the string and assigns a.b.c to it
 nav(a.b.c CLONE_DEEP d.e.f) clones the value of d.e.f depely and assigns it to a.b.c




## <a name="navigation_expression_parse"></a> `navigation_expression_parse`





## <a name="ref_keys"></a> `ref_keys`





## <a name="ref_nav_create_path"></a> `ref_nav_create_path`





## <a name="ref_nav_get"></a> `ref_nav_get`





## <a name="ref_nav_set"></a> `ref_nav_set`





## <a name="ref_prop_get"></a> `ref_prop_get`





## <a name="ref_prop_set"></a> `ref_prop_set`







