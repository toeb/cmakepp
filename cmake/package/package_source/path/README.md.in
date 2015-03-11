

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
