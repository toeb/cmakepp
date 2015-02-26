## Package Management

Package management depends on package search and retrieval.  The other way around there are no dependencies. This clean cut is and will stay important

# Project


## The Project Lifecycle

* `project_new` a project is created which does not know anything
* `project_load` project configuration is loaded into `project_handle.configuration`
  - qualfied paths are set in `project_handle` 
    + `content_dir` were the projects content is
    + `dependency_dir` were the dependencies of the project are installed to
    + `config_dir` were configuration files for the project are written
  - installed package load in arbitrary order except the project which is loaded last
    + event `project_on_package_load(<project handle> <package handle>)` is emitted
      * `cmakepp_project_on_package_load` is called 
        * `package_descriptor.cmakepp.export :<glob ignore>` all files specifed by globbing expression are loaded in the order specified.
        * `package_descriptor.cmakepp.hooks.on_load:<callable<` hook is invoked if it exists
        * event `on_package_load(<project handle> <package handle>)` is emitted
  - event `project_on_packages_loaded(<project handle> <package handle...>)` is emitted 
  - event `project_on_load(<project handle>)` is emitted
* `project_install(<package uri> [--reference]) ->` 
  - `package content and package handle is pulled and pushed into managed package source which is based in dependency_dir`
  - `package_descriptor.cmakepp.hooks.on_install(<project handle> <package handle>)` hook is invoked if it exists
  - event `project_on_package_load(<project handle> <package handle>)` is emitted
    * `cmakepp_project_on_package_load` is called 
      * `package_descriptor.cmakepp.export :<glob ignore>` all files specifed by globbing expression are loaded in the order specified.
      * `package_descriptor.cmakepp.hooks.on_load:<callable<` hook is invoked if it exists   
* `project_uninstall`
* `project_save`



# Package Descriptor

A `package descriptor` is a immutable collection of metadata which describes a package instance. It is retrieved from a package source via `resolve`.  I will discuss a couple of properties which are generally set here. However all properties are optional.

## Package Descriptor Properties 
* `id` the uniqueish (as in SHOULD be globally unique) identifier for a package.  The actual unique identifier is and will always be the `package_uri`. However the package itself is not aware of the `package_uri` as it can be stored at any location. 
* `version` the version SHOULD be a `semantic version`. However it may be any other type of string which identifies the unique instance of the package.  (e.g. it could be a git commit hash or tag name).  If the version is not a `semantic version` it will not be comparable and default to the version `0.0.0`
* `description` a description of what this package is and does
* `authors` the person or people who worked on this package (see the [`AUTHORS`](#) format) `(<user name> =) <natural name> "<"<email address>">"`
* `owner` the person that is responsible for this package instance also in `AUTHORS` format
* `source_uri`
* `website_uri`
* `cmakepp` hooks and exports which `cmakepp` handles
 

# Package Handles

A `package handle` is an object which is used by `cmakepp` to handle packages. The only required field for the `package handle` is the `uri` field which needs to contain a `package uri`. Package handles are returned `package handle` by `package source` functions `query(--package handle)` `pull` `push` and `resolve`. Depending on how you retrieved the `package handle` the information which is contained will differ (e.g when a package was pulled the `package handle`'s `content_dir` property will be set but will not be set if it was only resolved)

An importand property of `package handle`'s is that they `MUST` be serializable. The data contained by the `package handle`

## Common `package handle` properties

* `uri` guaranteed to exist. the immutable, unique `package uri` identifying this package
* `query_uri` contains the uri with which the package was identified (may not be unique)
* `package_descriptor` guaranteed to exist if the `package handle` was `resolved`. Contains all immutable metadata of a specific `package instance`
* `content_dir` guaranteed to exist if the package was `pulled`. Contains the location of an instance of the `package`'s  files
* `descriptors` package sources may append custom information which might or might not be interesting to the package. See the `package source`'s documentation to see which descriptor will exist
    - `repo_descriptor` ...
    - `bitbucket_descriptor` ...
    - `github_descriptor` ...
    - `path_descriptor` ...
    - `archive_descriptor` ...


# Package Source

# Package Search and Retrieval

## Motivation

A best practice for retrieving and using third party libraries with a platform independent build system (for c++) is currently not available.  So I have decided to throw my hat in the ring by adding package control to cmake.  I compete with other great solutions in this area:

* [biicode]() a file based dependency management system depending on a central webservice. 
* [hunter]() a decentralized package manager with a central repository for `hunter gates` 
* [cpm]() a git, subversion and hg based package manager also indexes packages in a github repository

I want to be able to use decentralized package sources (ie not a centralized server through which all requests go) and be easily extinsible to incoporate other package services with minimal overhead.

I want package search and retrieval to be a very simple process so it can be applied generally. (no specialization on C++, no callbacks, installation, etc - these subjects are important and are adressed but not in respect to package search and retrieval) 

Using package search and retrieval as a base I will extend it by [dependency management](#) and [cpp project generation](#). 

## Implementation

I chose a very simple interface to handle packages *note: these functions exist for every `package source` (not globally) - except pull which is only implemented by writable data sources*:  

* `<package>` is an abstract term. It describes a set of files and meta information (`<package descriptor>`) which is identified by a `<package uri>`
* `<package descriptor>` meta information on a package. No constraint on the data is made. There are however some properties which have special meaning and are listed here
  * `id: <string>` the name of the `package` it should be uniqueish. At least in its usage context it should be unique.
  * `version: <semver>` the version of the package      
  * `...` other properties do not pertain to package search and retrieval but rather to project- and dependency-management these are described elsewhere.
* `<package uri>` is a `<uri>` of an existing uniquely identified `<package>` this uri identifies a `<package>`'s contents and `package descriptor` the content and meta information of the package SHOULD BE immutable. This constraint is needed to allow for dependency management and guaranteeing a package's reliability. Every ``package source`` will tell you what kind of guarantee it gives your.  
* `<package handle>`  a package handle is an object containing information on a package and has a unique key called `uri`.  The data varies for a package handle depending on the `package source` it stems from. Some sources might add more meta information than others. 
  - properties   
    * `uri :<package uri>` required. uniquely identifies this package
    * `package_descriptor: <package_descriptor?>` required after resolve (may be null or generated.)
    * `content_dir:<content dir>` required after successful pull 
    * `...`
* `query(<~uri> [--package-handle]) -> <package uri...>` takes a uri query and returns a list of unique unchanging `<package uri>` which will be valid now and generally in the future.  It is important to note the unchanging aspect as once a package is uniquely identified the user expects it only to change when he/she wants it to.
  * `--package-handle` will return a `<package handle>` instead of a `<package uri>`
  * `--refresh` will cause an update of any cache being used.  `package source`s which do not cache will silently ignore this flag.    
* `resolve(<~uri> [--refresh]) -> <package handle?>` takes a uri and returns a `<package handle>`  if the uri uniquely identifies a package.  If the uri specified is not unique null is returned.
  * `--refresh` will cause an update of any cache being used. `package source`s which do not cache will silently ignore this flag.   
* `pull(<~uri> <target_dir?> [--refresh] [--reference]) -> <package handle>` takes a uri which is resolved to a package.  The content of the package is then loaded into the specified target dir (relative to current `pwd`) The returned package handle will contain a property called `content_dir` which will normally but not necessarily be the same to `target_dir`
  - `--refresh` will cause an update of any cache being used
  - `--reference` will set the `content_dir` of the package handle to a local path which already contains the content associated with the `package uri` if the `package source` does not support the reference flag it ifnore the `--reference` flag
* `push(<~package handle> ...) -> <package uri>` the implemenation of this function is not necessary and not available for all `package source`s - it allows upload of a package to a `package source`. After the successfull upload the `<package uri>` is returned. 
  - `...` arguments dependening on the `package source` being used.

The `package source`s described hitherto all have a constructor function which returns a `package source` object. The `pull`/`push`/`resolve`/`query` implementations have a longer function name and SHOULD NOT be used directly but by calling them on the `package source` object using `call(...)` or `assign(...)`.

If your are just interested in pulling packages from a remote to a target directory you should use the [default package methods](#packages_default_methods): `pull_package`, `resolve_package`, `query_package`  which work globally and need no special `package source` object. 

*Examples*

```
## create a github package source and use it to find all local repositories of a github user and print them to the console
set(user "toeb")
assign(source = github_package_source())
assign(package_uris = source.query("${user}"))
message("all packages for ${user}")
foreach(package_uri ${package_uris})
  message("  ${package_uri}")
endforeach()
```
