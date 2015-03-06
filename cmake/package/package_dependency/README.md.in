# Dependency Management

Dependency management is based on package search and retrieval.  It uses the metadata returned by the `package source` to manage a dependency graph. 

The central data structure used by dependency management is the `dependency`.  It is a key value pair and defined as follows:

```
<dependency> ::= {
  <dependency uri>:<dependency constraint>
}
<dependency contraint> ::= 
  <true>  # indicates that the specified dependency needs to be satisfied for the dependee to be satisfied
 |<false> # indicates that the specified dependency may not be satisfied if the dependee is to be satisfied
 |<null>  # indicates that the dependency is optional
 |{       # a constraint object indicates that the dependency is required (like <true>)
  content_dir: <relative path> # the path relative to the project into which the dependency will be pulled
 }
```

The `dependency`s plural form is `dependencies`. It combines the `dependency`s into a single object.  The constraints are `and`ed together if the `dependency uri` is the same: `<dependencies> ::= {<<dependency uri>:<dependency constraing>>...}`


**Example `<dependency>`s**

```
{ 'bitbucket:eigen/eigen':true }
{ 
  'github:toeb/cmakepp':{ 
    content_dir: 'cmake/cmakepp',
    version: '>=0.0.5'
  }
}
{ 'github:toeb/cmakepp/tags/v0.0.4':false }
```


