# Package Source

### Package Sources

A `package source` is a set of methods and possibly some implementation specific properties.  The interface for a `package source` was already described and consists of the methods.
* `query`
* `resolve`
* `pull`
* `push` *optional*

In the following sections the package source implementations are briefly discussed. 







## <a name="package_sources"></a> Package Sources



## <a name="package_source_default"></a> Default Package Source
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



#### git package source

Uses the source code management sytem `git` to access a package.  A git repository is interpreted as a package with refs (tags/branches/hashes) being interpreted as different version.

* `query uri format` - takes any uri which git can use (`https`, `ssh`, `git`, `user internally `git ls-remote` is used to check if the uri points to a valid repository. You can specify a ref, branch or tag by appending a query to the uri e.g. `?tag=v0.0.1`
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



#### managed package source

A managed package source has a `source_name` and a `directory` which it manages.  The managed package source should be considered as a black box and should only be accessed via its (push, pull, query and resolve) methods.

* `query uri format`
* `package uri format` `<source_name>:<package hash>`
* `<package handle>` the package handle contains extra fields






#### directory package source 

The directory package source has a `source_name` and a `directory` associated with it. It treets every `subdirectory` as a possible package and allows query, resolve and pull operations on them.  The `package descriptor` is sought for in the `subdirectory`s `package descriptor file`  The content is copied as is described by the `path package source`

* Functions
  - `<directory package source> ::= { source_name:<string>, directory:<path>, query:<function>, resolve:<function>, pull:<function>  }`
  - `directory_package_source(<source_name> <directory: <path>>) -> <directory package source>`
  - 



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


