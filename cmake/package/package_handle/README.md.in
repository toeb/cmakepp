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

