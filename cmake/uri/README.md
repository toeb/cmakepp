## <a name="uris"></a> Uniform Resource Identifiers (URIs)

Uniform Resource Identifiers are often used for more than just internet addresses.  They are able to identify any type of resource and are truly cross platform.  Even something as simple as parsing a path can take on complex forms in edge cases.  My motivation for writing an URI parser was that I needed a sure way to identify a path in a command line call. 

My work is based arround [RFC2396](https://www.ietf.org/rfc/rfc2396.txt) by Berners Lee et al.  The standard is enhanced by allowing delimited URIs and Windows Paths as URIs. You can always turn this behaviour off however and use flags to use the pure standard.

URI parsing with cmake is not something you should do thousands of times because alot of regex calls go into generating an uri object.

## Example

*Parse an URI and print it to the Console*
```
uri("https://www.google.de/u/0/mail/?arg1=123&arg2=arg4#readmails some other data")
ans(res)
json_print(${res})
```

*output*
```
{
 "input":"https://www.google.de/u/0/mail/?arg1=123&arg2=arg4#readmails some other data",
 "uri":"https://www.google.de/u/0/mail/?arg1=123&arg2=arg4#readmails",
 "rest":" some other data",
 "delimiters":null,
 "scheme":"https",
 "scheme_specific_part":"//www.google.de/u/0/mail/?arg1=123&arg2=arg4#readmails",
 "net_path":"www.google.de/u/0/mail/",
 "authority":"www.google.de",
 "path":"/u/0/mail/",
 "query":"arg1=123&arg2=arg4",
 "fragment":"readmails",
 "user_info":null,
 "user_name":null,
 "password":null,
 "host_port":"www.google.de",
 "host":"www.google.de",
 "labels":[
  "www",
  "google",
  "de"
 ],
 "top_label":"de",
 "domain":"google.de",
 "ip":null,
 "port":null,
 "trailing_slash":false,
 "last_segment":"mail",
 "segments":[
  "u",
  0,
  "mail"
 ],
 "encoded_segments":[
  "u",
  0,
  "mail"
 ],
 "file":"mail",
 "extension":null,
 "file_name":"mail"
}
```

*Absolute Windows Path*

```
# output for C:\windows\path
{
 "input":"C:\\windows\\path",
 "uri":"file:///C:/windows/path",
 "rest":null,
 "delimiters":null,
 "scheme":"file",
 "scheme_specific_part":"///C:/windows/path",
 "net_path":"/C:/windows/path",
 "authority":null,
 "path":"/C:/windows/path",
 "query":null,
 "fragment":null,
 "user_info":null,
 "user_name":null,
 "password":null,
 "host_port":null,
 "host":null,
 "labels":null,
 "top_label":null,
 "domain":null,
 "ip":null,
 "port":null,
 "trailing_slash":false,
 "last_segment":"path",
 "segments":[
  "C:",
  "windows",
  "path"
 ],
 "encoded_segments":[
  "C:",
  "windows",
  "path"
 ],
 "file":"path",
 "extension":null,
 "file_name":"path"
}
```


*Perverted Example*
```
uri("'scheme1+http://user:password@102.13.44.22:23%54/C:\\Program Files(x86)/dir number 1\\file.text.txt?asd=23#asd'")
ans(res)
json_print(${res})
```
*output*
```
{
 "input":"'scheme1+http://user:password@102.13.44.32:234/C:\\Progr%61m Files(x86)/dir number 1\\file.text.txt?asd=23#asd'",
 "uri":"scheme1+http://user:password@102.13.44.32:234/C:/Progr%61m%20Files(x86)/dir%20number%201/file.text.txt?asd=23#asd",
 "rest":null,
 "delimiters":null,
 "scheme":"scheme1+http",
 "scheme_specific_part":"//user:password@102.13.44.32:234/C:/Progr%61m%20Files(x86)/dir%20number%201/file.text.txt?asd=23#asd",
 "net_path":"user:password@102.13.44.32:234/C:/Progr%61m%20Files(x86)/dir%20number%201/file.text.txt",
 "authority":"user:password@102.13.44.32:234",
 "path":"/C:/Progr%61m%20Files(x86)/dir%20number%201/file.text.txt",
 "query":"asd=23",
 "fragment":"asd",
 "user_info":"user:password",
 "user_name":"user",
 "password":"password",
 "host_port":"102.13.44.32:234",
 "host":"102.13.44.32",
 "labels":null,
 "top_label":null,
 "domain":null,
 "ip":"102.13.44.32",
 "port":234,
 "trailing_slash":false,
 "last_segment":"file.text.txt",
 "segments":[
  "C:",
  "Program Files(x86)",
  "dir number 1",
  "file.text.txt"
 ],
 "encoded_segments":[
  "C:",
  "Progr%61m%20Files(x86)",
  "dir%20number%201",
  "file.text.txt"
 ],
 "file":"file.text.txt",
 "extension":"txt",
 "file_name":"file.text"
}
```

## DataTypes and Functions

* `<uri> ::= `
  * `uri:<string>` all of the uri as specified 
  * `scheme:<string>` the scheme part of the uri without the colon e.g. `https` from `https://github.com`  
  * `scheme_specific_part` the part of the uri that comes after the scheme and its colon e.g. `//github.com` from the previous example
  * `autority:<string>` the domain, host,port and user info part of the domain 
  * `path:<string>` the hierarchical part of the uri 
  * `query:<string>` the query part of the uri
  * `fragment:<string>` the fragment part of the uri
* `<uri~> ::= <string>|<uri>` a uri or a string which can be converted into a valid uri
* `uri(<uri~>):<uri>` 
* `uri_parse(<uri_string:<string>> <?--notnull> <?--file> <?--escape-whitespace> <?--delimited> ):<uri?>`
  * `<--escape-whitespace>` 
  * `<--file>` 
  * `<--notnull>` 
  * `<--delimited>` 
* `uri_to_path(<uri~>):<string>`
* 


## Caveats

* Parsing is always a performance problem in CMake therfore parsing URIs is also a performance problem don't got parsing thousands of uris. I Tried to parse 100 URIs on my MBP 2011 and it took 6716 ms so 67ms to parse a single uri
* Non standard behaviour can always ensue when working with file paths and spaces and windows.  However this is the closest I came to having a general solution

## Future Work

* allow more options for parsing
* option for quick parse or slow parse
