# Project


## Motivation

Package or Dependency management is not a new Idea.  Most Build systems for other languages have some kind of support for automatically handling packages.

## Concept

* slides from ryppl
* reddit thread
* ...


## State of the Art



## Implementation

Working with dependencies implies that you are using a dependency graph. The root node from which you work is what I call the `project`.  

The `project` is represented by the `project_handle` which is a `package_handle` and behaves as expected in all situations except that it has also has property called `project_descriptor` which contains project specific information.  The `project_descriptor` contains the whole object graph consisting of every `package handle` used in the project and all their properties.  Every `package_handle` (which is identified by an `package_uri`) is unique and only one reference will exist for it inside a project.  This while object graph is serialized and deserialized using the `scmake` serialization format (see `cmake_serialize` `cmake_deserialize`) which is able to persist the data including cycles and is quite fast (in comparison with other serializers).  It is important that the no data is added to the object graph which is not serializable.

The `project_descriptor` is contains the following:

```
<project descriptor> ::= {
   package_cache: { <admissable uri> : <package handle> } # contains all packages known to project
   package_source: <package source> a package source object used to retrieve package metadata and files.
   package_materializations: { <package uri> : <package handle> } # contains all materialized packages.
   dependency_configuration: { <package_uri> : <bool> } # the currently configured dependencies
   dependencies: { <package uri>:<package handle> } # all dependencies that this project has including transient dependencies. 
   dependency_dir: <path = "packages"> # path relative to project root which is used as a the default dependency locations
   config_dir: <path = ".cps"> # the locations of the configuration folder 
   project_file: <path = ".cps/project.scmake"> # the location of the project's config file
   package_descriptor_file: <path>?  # if specified the path of the package descriptor.  This will be read or written when project is opened or closes
}
```

## The Commmand Line Interface

Of course using the package functionality is possbile by using a command line interface.  It allows you to use the functions specified bellow and loads and stores you project automatically.  




## Function List

To work with the project I provide you with the following functions.


* [project_open](#project_open)
* [project_close](#project_close)
* [project_read](#project_read)
* [project_write](#project_write)


## The Project Lifecycle
 

* `closed`
    - The project handle does not exist / or should not be used
    - `project_read` `->` `opening`

* `opening` 
    - `-> opened, loaded`
* `unloaded`
    - `project_load -> loading`
* `loading`   
* `loaded`
    - `project_unload -> unloading`     
    - `project_close -> closing`     
* `materializing`
    - all dependencies are loaded
    - all materializations which are not dependencies are also loaded
* `openend` 
    - everything `of opening` 
* `closing`


The project's lifecycle is also characterized  by the events that are emitted.  
The key to understanding the project lifecycle lies within these events.


* `project_on_opening(<project handle>)` called after project handle is created.  Called before project is loaded. 
* `project_on_opened` called after project handle is created and project is loaded. 
* `project_on_loading` called before any dependencies are loaded
* `project_on_loaded` called after all dependencies and project was loaded
* `project_on_package_loading` called before packages's dependencies are loaded.
* `project_on_package_loaded` called after package's dependencies are loaded.  
* `project_on_package_reload` called when a package was already loaded but is the dependency of another package
* `project_on_package_cycle` called `project_load` when a dependency cycle is detected. 
* `project_on_package_materialized` called by `project_materialize` before package content is pulled.  
* `project_on_package_materialized` called by `project_materialize` after the package content is pulled.   
* `project_on_dependency_configuration_changed` called by `project_change_dependencies` when the dependency after the dependency configuration was changed.
* `project_on_dependencies_materializing` called by `project_materialize_dependencies` before any dependencies are materialized/dematerialized
* `project_on_dependencies_materialized` called after all dependencies where successfully materialized/dematerialized
* `project_on_package_dematerializing` called by `project_dematerialize` before the package content is removed
* `project_on_package_dematerialized` called by `project_dematerialize` after the package content was removed
* `project_on_unloading` called by `project_unload`, `project_close` before any dependencies are unloaded
* `project_on_unloaded` called by `project_unload`, `project_close` after all dependencies are unloaded
* `project_on_package_unloading` called by `project_unload` before any of `package`'s  dependencies were unloaded
* `project_on_package_unloaded` called by `project_unload` after all of `package`'s dependencies were unloaded 
* `project_on_closing` called before the project is `closed` and before it is `unloaded`
* `project_on_closed` called after the project was `closed` and all packages where `unloaded`


## `cmakepp` integration

`cmakepp` listens for the project events and uses them to to provide extra functionality which is described here

* `package_descriptor.cmakepp.create_files : { <filename> : <filecontent> }` all keys specified here will be created in the `package`'s `content_dir` with the specified content. This is useful if you want to define a package completely in a `package descriptor`
* `package_descriptor.cmakepp.export : <glob ignore expression>` includes all the files specified by the glob ignore expression in cmake allowing your package to provide cmake macros and functions to other packages.  **WARNING** cmake only has one function scope so you need to be careful that you do not overwrite any functions which are needed elsewhere.  The best practice would be for you to add a namespace string before each function name e.g. `mypkg_myfunction`.  

### `cmakepp` Hooks

Hooks are invoked for every package which allows it to react to the project lifecycle  more easily.  These hooks are called using `package_handle_invoke_hook`. You can use any function that you defined in your `cmakepp.export`s (except if stated otherwise) and also specify a file relative to the `package`'s root direcotry. 

* `package_descriptor.cmakepp.hooks.on_loaded`  called after a package and all its dependencies are loaded.  You can also load custom data here or setup the project / package.
* `package_descriptor.cmakepp.hooks.on_unloading` called when the package is unloaded.  You can store all information that you want to keep in the `package_handle`. Or you could use this hook to persist custom data 
* `package_descriptor.cmakepp.hooks.on_materialized` called after the package content is available but before the package is loaded. Here you can only specifiy a script file because the exports might not be available (but you can include them yourself)
* `package_descriptor.cmakepp.hooks.on_dematerializing` called before the package dematerializes. this allows you to perform cleanup before the package content is destroyed
* `package_descriptor.cmakepp.hooks.on_run` called on project package if when command line client is invoked (see `cmakepp_project_cli`)
* `package_descriptor.cmakepp.hooks.on_ready` is invoked when all become ready and the package itself is materialized
* `package_descriptor.cmakepp.hooks.on_unready` is invoked if any dependency becomes unready

#### States



* `unloaded`
  - `on_loaded -> loaded`
* `loaded`, `unready`
  - `on_dematerializing -> unloading`
  - `on_ready -> loaded, ready`
* `loaded`, `ready`
  - `on_unready -> loaded, unready`
  - `on_dematerializing -> unloading`
* `unloading`
  - `on_unloading -> unloaded`



## Caveats

Speed.  `CMake` is slow.  And there are still alot of optimization possibilities in `cmakepp`.  Don't be mad if you wait much longer than other dependency managers.

## Function Descriptions

## <a name="project_open"></a> `project_open`

 `(<content_dir> [<~project handle>])-><project handle>` 

 opens the specified project by setting default values for the existing or new project handle and setting its content_dir property to the fully qualified path specified.
 if no project handle was given a new one is created.
 if the state of the project handle is `unknown` it was never opened before. It is first transitioned to `closed` after emitting the `project_on_new` event.
 then the project handle is transitioned from `closed` to `open` first the `project_on_opening` event is emitted followed by `project_on_open`.  Afterwards the state is changed to `open` and then the `project_on_opened` event us emitted.  
 returns the project handle of the project on success. fails if the project handle is in a state other than `unknown` or `closed`. 

 **events**
  * `project_on_new(<project handle>)`
  * `project_on_opening(<project handle>)`
  * `project_on_open(<project handle>)`
  * `project_on_opened(<project handle>)`
  * `project_on_state_enter(<project handle>)`
  * `project_on_state_leave(<project handle>)`

 **assumes** 
 * `project_handle.project_descriptor.state` is either `unknown`(null) or `closed`
 
 **ensures**
 * `content_dir` is set to the absolute path of the project
 * `project_descriptor.state` is set to `open`




## <a name="project_close"></a> `project_close`

 `(<project handle>)-><project file:<path>>`

 closes the specified project

 **events**
  * `project_on_closing(<project handle>)`
  * `project_on_close(<project handle>)`
  * `project_on_closed(<project handle>)`




## <a name="project_read"></a> `project_read`

 `(<package handle> | <project dir> | <project file>)-><project handle>`
 
  Opens a project at `<project dir>` which defaults to the current directory (see `pwd()`). 
  If a project file is specified it is openend and the project dir is derived.  
 
  Checks wether the project is consistent and if not acts accordingly. Loads the project and all its dependencies
  also loads all materialized packages which are not part of the project's dependency graph
 
 **returns** 
 * `<project handle>` the handle to the current project (contains the `project_descriptor`) 
 
 **events**
 * `project_on_opening(<project handle>)` emitted when the `<project handle>` exists but nothing is loaded yet
 * `project_on_open(<project handle>)` emitted  so that custom handlers can perform actions like loading, initializing, etc
 * `project_on_opened(<project handle>)` emitted after the project was checked and loaded
 * events have access to the follwowing in their scope: 
   * `project_dir:<qualified path>` the location of this projects root directory
   * `project_handle:<project handle>` the handle to the project 




## <a name="project_write"></a> `project_write`

 saves the project 






