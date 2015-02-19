
#### github package source

A package source which uses the github api to parse remote source packages. The idea is to use only the `<user>/<repo>` string to identify a source package.

* `query uri format` a combination of `<github user>/<github repo?>/<branch/tag/release?>`. specifying only the user returns all its repositories specifying user and repository will return the current default repository. specifying a branch will also check the branch
* `package uri format` a uri of the following format `github:<user>/<repo>/<ref?>`
* Functions
  - `github_package_source() -> <path package source>` returns a github package source object which the following implementations.  
  - `query: package_source_query_github(...)->...`
  - `resolve: package_source_resolve_github(...)-> <package handle?>` package handle contains a property called `repo_descriptor` which contains github specific data to the repository
  - `pull: package_source_pull_github(...)->...`

