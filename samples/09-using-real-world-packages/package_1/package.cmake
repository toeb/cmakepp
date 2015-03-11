{
  "id":"package_1",
  "version":"0.0.1-alpha",
  "cmakepp":{
    "export":["cmake/**.cmake", "--recurse"],
    "hooks":{
      "on_materialized":"install/materialize_script.cmake"
    }

  }


}