function(test) 
  set(res "")
  # single word changed to upper case
  set(str "else")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Else")

  set(res "")
  # v changed to lower case
  set(str "this V that")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This v That")

  set(res "")
  # v changed to lower case
  set(str "this V that")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This v That")

  set(res "")
  # small after a subsentence (1/2)
  set(str "Subsentence: a Sub")
  string_totitle("${str}")
  ans(res)

  set(res "")
  # Every word upper case
  set(str "abcdefg hello")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Abcdefg Hello")

  set(res "")
  # Small letter 'a' stays small
  set(str "abcdefg a hello")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Abcdefg a Hello")

  set(res "")
  # Keep whitespaces
  set(str "abcdefg a   hello")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Abcdefg a   Hello")

  set(res "")
  # words with dot inside stay small
  set(str "abcdefg a hel.lo")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Abcdefg a hel.lo")

  set(res "")
  # words with big letter elsewhere stay small
  set(str "abcdefg a heLLo")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Abcdefg a heLLo")

  set(res "")
  # beginning of sentence has 'small' -> uppercase
  set(str "a abcdefg hello a superTrump?")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "A Abcdefg Hello a superTrump?")

  set(res "")
  # small after a subsentence (1/2)
  set(str "Subsentence: a Sub")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Subsentence: A Sub")
  
  set(res "")
  # small after a subsentence (2/2)
  set(str "Subsentence! a Sub")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "Subsentence! A Sub")

  set(res "")
  # v stays lower case
  set(str "this v that")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This v That")

  set(res "")
  # v changed to lower case
  set(str "this Vs that")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This vs That")

  set(res "")
  # colo(u)r not changed to upper case
  set(str "this is not a colo(u)r?")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This Is Not a colo(u)r?")

  set(res "")
  # a at beginning (after quotes) changed to uppercase
  set(str "'a test'")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "'A Test'")

  set(res "")
  # quotes and a subsequent subsentence
  set(str "'a test': the subsentence")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "'A Test': The Subsentence")

  set(res "")
  # quotes and a subsequent subsentence
  set(str "'a test': 'the subsentence'")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "'A Test': 'The Subsentence'")

  set(res "")
  # words like "that's", "it's" should be upper case also
  set(str "'a word': 'look, that's a subsentence isn't it?")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "'A Word': 'Look, That's a Subsentence Isn't It?")

  set(res "")
  # "'" (and "," etc.) does not start a subsentence (1/2)
  set(str "This is a word, a word")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This Is a Word, a Word")

  set(res "")
  # "'" (and "," etc.) does not start a subsentence (2/2)
  set(str "This is a word' a word")
  string_totitle("${str}")
  ans(res)
  assert("${res}" STREQUAL "This Is a Word' a Word")
endfunction()
