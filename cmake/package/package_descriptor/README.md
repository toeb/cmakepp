
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
 