
#### composite package source

A composite package source manages a list of sub data sources and uses a rating algorithm to select the correct source.  If one of the schemes of an uri matches a `package sources`'s `source_name` it is selected. Else the `package source`'s `rate_uri(<uri>)-><int>` method is called which returns a value from `0` to `999` where `0` means package source cannot handle the uri and `999` means package source is the only one which can handle the uri. The sources are ordered by the rating and queried in order.

* `query uri format`
* `<package handle>` contains the property `rating` which contains the rating of the uri and `package_source` which contains the package source which handles the `uri`
* 
 