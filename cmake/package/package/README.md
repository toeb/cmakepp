# Package


## The `uri`

The `uri` is a uniform resource identifier which is defined by [RFC2396](https://www.ietf.org/rfc/rfc2396.txt).  It is used by `package source`s to search and retrieve packages. 

## The `admissable uri`

When a this `uri` is put into a `package source`'s `rate_uri` method it returns a `boolish` value. If this value evaluates to `true` it means that the package source is capable of handling this specific uri. If `rate_uri` returns a value evaluating to `false` it means that the `package source` is not able to handle that `uri`.   

A `package source` returns a rating of `>=1` for an `admissable uri` it indicates that the `package source` is able to `query` for this type of `uri`. 
If a `package source` returns a rating of `>=999` for an uri it means that it alone sees itself responsible for handling that uri.  The rating a term used especially when working with multiple package sources. 

All `uri`s  which are not `admissable uri`s are `inadmissable uri`s

## The `volatile uri`

A `volatile uri` uniquely identifies a package at a specific point in time. However as time passes the `volatile uri` may identify multiple or no packages at all.  A `volatile uri` can always be resolved to a `package handle` using the `package source`'s `resolve` function.

## The `dependable uri`

This kind of `uri` is obtained by calling `package source`'s `query` method.  The query method transforms any kind of `uri` into a set of `dependendable uri`s. An `admissable uri` is returns `0...n` `dependable uri` an `inadmissable uri` always returns `0` `dependendable uri`s. A `volatile uri` always returns exactly `1` `dependable uri`. 