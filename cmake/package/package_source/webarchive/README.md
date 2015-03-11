
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
