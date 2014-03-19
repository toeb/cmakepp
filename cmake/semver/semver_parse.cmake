
function(semver_parse version_string)
map_isvalid("${version_string}" ismap)
if(ismap)
  semver_format(version_string ${version_string})
endif()

 set(semver_identifier_regex "[0-9A-Za-z-]+")
 set(semver_major_regex "[0-9]+")
 set(semver_minor_regex "[0-9]+")
 set(semver_patch_regex "[0-9]+")
 set(semver_identifiers_regex "${semver_identifier_regex}(\\.${semver_identifier_regex})*") 
 set(semver_prerelease_regex "${semver_identifiers_regex}")
 set(semver_metadata_regex "${semver_identifiers_regex}")
 set(semver_version_regex "(${semver_major_regex})\\.(${semver_minor_regex})\\.(${semver_patch_regex})")
 set(semver_regex "(${semver_version_regex})(-${semver_prerelease_regex})?(\\+${semver_metadata_regex})?")

  cmake_parse_arguments("" "" "MAJOR;MINOR;PATCH;VERSION;VERSION_NUMBERS;PRERELEASE;METADATA;RESULT;IS_VALID" "" ${ARGN})

  map_create(version)

  # set result to version (this will contain partial or all of the version information)
  if(_RESULT)
    set(${_RESULT} ${version} PARENT_SCOPE)
  endif()

  string(REGEX MATCH "^${semver_regex}$" match "${version_string}")
  # check if valid
  if(NOT match)
    set(${_IS_VALID} false PARENT_SCOPE)
    return()
  endif()
  set(${_IS_VALID} true PARENT_SCOPE)

  # get version metadata and comparable part
  string_split(parts "${version_string}" "\\+")
  list_first(version_version ${parts})
  list_rest(version_metadata ${parts})

  # get version number part and prerelease part
  string_split(parts "${version_version}" "-")
  list_first(version_number ${parts})
  list_rest(version_prerelease ${parts})

  # get version numbers
  string(REGEX REPLACE "^${semver_version_regex}$" "\\1" version_major "${version_number}")
  string(REGEX REPLACE "^${semver_version_regex}$" "\\2" version_minor "${version_number}")
  string(REGEX REPLACE "^${semver_version_regex}$" "\\3" version_patch "${version_number}")

  string(REGEX REPLACE "\\." "\;" version_metadata "${version_metadata}")
  string(REGEX REPLACE "\\." "\;" version_prerelease "${version_prerelease}")

  if(_MAJOR)
    set(${_MAJOR} ${version_major} PARENT_SCOPE)
  endif()
  if(_MINOR)
    set(${_MINOR} ${version_minor} PARENT_SCOPE)
  endif()
  if(_PATCH)
    set(${_PATCH} ${version_patch} PARENT_SCOPE)
  endif()

  if(_VERSION)
    set(${_VERSION} ${version_version} PARENT_SCOPE)
  endif()

  if(_VERSION_NUMBERS)
    set(${_VERSION_NUMBERS} ${version_number} PARENT_SCOPE)
  endif()

  if(_PRERELEASE)
    set(${_PRERELEASE} ${version_prerelease} PARENT_SCOPE)
  endif()

  if(_METADATA)
    set(${_METADATA} ${version_metadata} PARENT_SCOPE)
  endif()

  if(_RESULT)
    element(MAP res)
      value(KEY major "${version_major}")
      value(KEY minor "${version_minor}")
      value(KEY patch "${version_patch}")
      value(KEY prerelease "${version_prerelease}")
      value(KEY metadata "${version_metadata}")
    element(END)
    set(${_RESULT} ${res})
  endif()

endfunction()