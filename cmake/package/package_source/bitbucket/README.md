
#### bitbucket package source

A package source which uses the bitbucket api to parse remote source packages. 

* `query uri format` a combination of `<bitbucket user>/<bitbucket repo?>/<branch/tag/release?>`. specifying only the user returns all its repositories specifying user and repository will return the current default repository. specifying a branch will also check the branch
* `package uri format` a uri of the following format `bitbucket:<user>/<repo>/<ref?>`
* Functions
  - `bitbucket_package_source() -> <path package source>` returns a bitbucket package source object which contains the following methods.
  - `package_source_query_bitbucket(...)->...`
  - `package_source_resolve_bitbucket(...)-> <package handle?>` package handle contains a property called `repo_descriptor` which contains bitbucket specific data to the repository
  - `package_source_pull_bitbucket(...)->...`
