## <a name="package_dependency_change_parse"></a> `package_dependency_change_parse`

 `(<change action>)->[ <admissable uri>, <action>]`

 parses a change action `<change action> ::= <admissable uri> [" " <action>]`
 `<action> ::= "add"|"remove"|"optional"|<dependency constraint>`
 the default action is `add`




