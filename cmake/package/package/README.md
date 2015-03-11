# Package


## The `uri`

The `uri` is a uniform resource identifier which is defined by [RFC2396](https://www.ietf.org/rfc/rfc2396.txt).  It is used by `package source`s to search for and retrieve packages. 

## The `admissable uri`

An  `uri` can be rated using the `package_source_rate_uri` function. If the `rating` is a `truish` value the specified `uri` is an `admissable uri`.  If the `rating` is `falsish` the `uri` is an `inadmissable uri`.  

A `package source` returns a `rating` of `>=1` for an `admissable uri` it indicates that the `package source` is able to `query` for this type of `uri`. 
If a `package source` returns a rating of `>=999` for an uri it means that it sees itself solely responsible for handling that `uri`.  The `rating` is a term especially used when working with multiple package sources. 

## The `volatile uri`

A `volatile uri` uniquely identifies a package at a specific point in time. However as time passes the `volatile uri` may devolve back into an `admissable uri` which means that it will identify multiple or no packages at all.  A `volatile uri` can always be resolved to a `package handle` using the `package source`'s `resolve` function.

## The `dependable uri`

The `dependeable uri` is obtained by calling the `package source`'s `query` method.  The query method transforms any kind of `uri` into a set of `dependendable uri`s. An `admissable uri` returns `0...n` `dependable uri` an `inadmissable uri` always returns `0` `dependendable uri`s. A `volatile uri` always returns exactly `1` `dependable uri`. 