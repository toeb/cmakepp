## `(<&cmake token>)-><cmake token>`
## 
## goes back one token and assigns the token ref 
## to the previous token
macro(cmake_token_go_back token_ref)
  map_tryget(${${token_ref}} previous)
  ans(${token_ref})
endmacro()

