# Project


## Installing a new package

* `install {<uri> <?content dir> <?>  }`
  * `resolve` package 
    * `foreach dependency in dependencies: install dependency`
  * `resolve` from remote `push` to managed package source`
    - package content exists in content dir
    - project can find package 
  * call `on_after_pull` hook - this can be used to download custom files or do other extra work that need to be done so that the package content is complete. 
  * check and install `dependencies`
  * 




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
