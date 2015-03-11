
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
