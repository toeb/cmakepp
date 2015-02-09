## Package Management

Package management depends on package search and retrieval.  The other way around there are no dependencies. This clean cut is and will stay important

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

# <a href="packages"></a> Package Search and Retrieval

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

### <a href="packages_default_methods"></a> Default Package Source nad Default Package Functions

The default package source combines access to github, bitbucket,webarchives, git, svn, hg, local archives and local dirs in a single package source. 

It can be accessed conveniently by these global functions

* `default_package_source() -> <default package source>`
* `query_package(<~uri>):<package uri...>`
* `resolve_package(<~uri>):<package handle?>`
* `pull_package(<~uri> <target dir?>):<package handle>`

*Examples*

```

## pull a github package to current user's home dir from github
pull_package("toeb/cmakepp" "~/current_cmakepp")

## pull a bitbucket package to pwd
pull_package("eigen/eigen")

## pull a package which exists in both bitbucket and github under the same user/name from github
pull_package("github:toeb/test_repo")

## find all packages from user toeb in bitbucket and github

assign(package_uris = query_package(toeb))
foreach(package_uri ${package_uris})
  message("  ${package_uri}")
endforeach()

```

### Package Sources

A `package source` is a set of methods and possibly some implementation specific properties.  The interface for a `package source` was already described and consists of the methods.
* `query`
* `resolve`
* `pull`
* `push` *optional*

In the following sections the package source implementations are briefly discussed. 

#### github package source

A package source which uses the github api to parse remote source packages. The idea is to use only the `<user>/<repo>` string to identify a source package.

* `query uri format` a combination of `<github user>/<github repo?>/<branch/tag/release?>`. specifying only the user returns all its repositories specifying user and repository will return the current default repository. specifying a branch will also check the branch
* `package uri format` a uri of the following format `github:<user>/<repo>/<ref?>`
* Functions
  - `github_package_source() -> <path package source>` returns a github package source object which the following implementations.  
  - `query: package_source_query_github(...)->...`
  - `resolve: package_source_resolve_github(...)-> <package handle?>` package handle contains a property called `repo_descriptor` which contains github specific data to the repository
  - `pull: package_source_pull_github(...)->...`


#### bitbucket package source

A package source which uses the bitbucket api to parse remote source packages. 

* `query uri format` a combination of `<bitbucket user>/<bitbucket repo?>/<branch/tag/release?>`. specifying only the user returns all its repositories specifying user and repository will return the current default repository. specifying a branch will also check the branch
* `package uri format` a uri of the following format `bitbucket:<user>/<repo>/<ref?>`
* Functions
  - `bitbucket_package_source() -> <path package source>` returns a bitbucket package source object which contains the following methods.
  - `package_source_query_bitbucket(...)->...`
  - `package_source_resolve_bitbucket(...)-> <package handle?>` package handle contains a property called `repo_descriptor` which contains bitbucket specific data to the repository
  - `package_source_pull_bitbucket(...)->...`


#### path package source

* `query uri format` - takes any local `<path>` (relative or absolute) or local path uri (`file://...`) that is points to an existing directory. (expects a `package descriptor file` in the local directory. 
* `package uri format` - a file schemed uri with no query which contains the absolute path of the package (no relative paths allowed in *unique* resource identifier)
* Functions
  - `path_package_source() -> <path package source>` returns a path package source object which ontains the methods described above 
  - `package_source_query_path(...)->...`
  - `package_source_resolve_path(...)->...`
  - `package_source_pull_path(...)->...`
  - `package_source_push_path(...)->...`

*Examples*

* valid query uris
  - `../pkg` relative path
  - `C:\path\to\package` absolute windows path
  - `pkg2` relative path
  - `/home/path/pkg3` absolute posix path
  - `~/pkgX` absolute home path 
  - `file:///C:/users/tobi/packages/pkg1` valid file uri 
  - `file://localhost/C:/users/tobi/packages/pkg1` valid file uri 
* valid package uris
  - `file:///usr/local/pkg1`
  - `file://localhost/usr/local/pkg1`
* valid local package dir
  - contains `package.cmake` - a json file describing the package meta data

#### archive package source

*Note: Currently only application/x-gzip files are supported - the support for other formats is automatically extended when decompress/compress functions support new formats*

* `query uri format` - takes any local `<path>`  (relative or absolute) or local path uri (`file://...`) that points to an existing archive file (see `compress`/`decompress` functions)
* `package uri format` - a file schemed uri which contains the absolute path to a readable archive file.
* Functions
  - `archive_package_source() -> <archive package source>`
  - `package_source_query_archive(...)->...`
  - `package_source_resolve_archive(...)->...`
  - `package_source_pull_archive(...)->...`
  - `package_source_push_archive(...)->...`

*Examples*

* valid query uris
  - `../pkg.tar.gz` relative path
  - `C:\path\to\package.gz` absolute windows path to existing tgz file
  - `pkg3.7z` (does not work until decompress works with 7z files however correct nonetheless)
  - `~/pkg4.gz` home path
  - `file:///path/to/tar/file.gz`
* valid package uris
  - `file:///user/local/pkg1.tar.gz`
  - `file://localhost/usr/local/pkg1.tar.gz`

#### web archive package source

*Note: same as local archive*

* `query uri format` - takes any uri which points to downloadable archive file. (including query) (normally the scheme would be `http` or `https` however only the protocol needs to be http as this package source sends a `HTTP GET` request to the specified uri.)  See `http_get` for more information on how to set up security tokens etc. 
* `package uri format` - same as `query uri format`
* Functions
  - `webarchive_package_source() -> <webarchive package source>`
  - `package_source_query_webarchive(...)->...`
  - `package_source_resolve_webarchive(...)->...` tries to read the `package descriptor` inside the archive.  If that fails tries to parse the filename as a package descriptor. 
  - `package_source_pull_webarchive(...)->...`
  - NOT IMPLEMENTED YET `package_source_push_webarchive(<~package handle> <target: <~uri>>)->...` uses `http_put` to upload a package to the specified uri

*Examples*

* valid query uris
  - `http://downloads.sourceforge.net/project/jsoncpp/jsoncpp/0.5.0/jsoncpp-src-0.5.0.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjsoncpp%2F&ts=1422460575&use_mirror=switch`
  - `http://github.com/lloyd/yajl/tarball/2.1.0`

#### git package source

Uses the source code management sytem `git` to access a package.  A git repository is interpreted as a package with refs (tags/branches/hashes) being interpreted as different version.

* `query uri format` - takes any uri which git can use (`https`, `ssh`, `git`, `user@host:repo.git`) internally `git ls-remote` is used to check if the uri points to a valid repository. You can specify a ref, branch or tag by appending a query to the uri e.g. `?tag=v0.0.1`
* `package uri format` - same as `query uri format` but with the additional scheme `gitscm` added
* Functions
  - `git_package_source()`
  - `package_source_query_hg(<~uri>) -> <package uri...>` 
  - `package_source_resolve_hg(<~uri>) -> <package uri...>` 
  - `package_source_pull_hg(<~uri>) -> <package uri...>` 

#### mercurial package source

Uses the source code management system `mercurial` to access packages. 

* `query uri format` - any uri which the `hg` executable can use 
* `package uri format` - same as `query uri format` but with the additional scheme `hgscm` added. The query only contains `?<ref type>=<ref>` if a specific revision is targeted
* Functions
  - `hg_package_source()-> <hg package source>`
  - `package_source_query_hg(<~uri>) -> <package uri...>` 
  - `package_source_resolve_hg(<~uri>) -> <package uri...>` 
  - `package_source_pull_hg(<~uri>) -> <package uri...>` 

#### subversion package source

uses the source code management system `subversion` to access packages

* Functions
  - `svn_package_source()-> <hg package source>`
  - `package_source_query_svn(<~uri>) -> <package uri...>` 
  - `package_source_resolve_svn(<~uri>) -> <package uri...>` 
  - `package_source_pull_svn(<~uri>) -> <package uri...>` 


#### composite package source

A composite package source manages a list of sub data sources and uses a rating algorithm to select the correct source.  If one of the schemes of an uri matches a `package sources`'s `source_name` it is selected. Else the `package source`'s `rate_uri(<uri>)-><int>` method is called which returns a value from `0` to `999` where `0` means package source cannot handle the uri and `999` means package source is the only one which can handle the uri. The sources are ordered by the rating and queried in order.

* `query uri format`
* `<package handle>` contains the property `rating` which contains the rating of the uri and `package_source` which contains the package source which handles the `uri`
* 
 
#### cached package source

The cache package source caches the package query and resolve requests so that accessing them is quick.  

* Functions
  - `cache_package_source(<inner: <package source>>) -> <cached package source>`
  - `package_source_query_cached(...)->...`
  - `package_source_resolve_cached(...)->...`
  - `package_source_pull_cached(...)->...`


#### directory package source 

The directory package source has a `source_name` and a `directory` associated with it. It treets every `subdirectory` as a possible package and allows query, resolve and pull operations on them.  The `package descriptor` is sought for in the `subdirectory`s `package descriptor file`  The content is copied as is described by the `path package source`

* Functions
  - `<directory package source> ::= { source_name:<string>, directory:<path>, query:<function>, resolve:<function>, pull:<function>  }`
  - `directory_package_source(<source_name> <directory: <path>>) -> <directory package source>`
  - 

#### managed package source

A managed package source has a `source_name` and a `directory` which it manages.  The managed package source should be considered as a black box and should only be accessed via its (push, pull, query and resolve) methods.

* `query uri format`
* `package uri format` `<source_name>:<package hash>`
* `<package handle>` the package handle contains extra fields



