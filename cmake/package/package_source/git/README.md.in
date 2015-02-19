
#### git package source

Uses the source code management sytem `git` to access a package.  A git repository is interpreted as a package with refs (tags/branches/hashes) being interpreted as different version.

* `query uri format` - takes any uri which git can use (`https`, `ssh`, `git`, `user internally `git ls-remote` is used to check if the uri points to a valid repository. You can specify a ref, branch or tag by appending a query to the uri e.g. `?tag=v0.0.1`
* `package uri format` - same as `query uri format` but with the additional scheme `gitscm` added
* Functions
  - `git_package_source()`
  - `package_source_query_hg(<~uri>) -> <package uri...>` 
  - `package_source_resolve_hg(<~uri>) -> <package uri...>` 
  - `package_source_pull_hg(<~uri>) -> <package uri...>` 
