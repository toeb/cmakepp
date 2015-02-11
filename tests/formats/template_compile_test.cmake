function(test)


  template_run("@foreach(i RANGE 1 3)@i@endforeach()")
  ans(res)
  assert("${res}" STREQUAL 123)

  template_run("@@")
  ans(res)
  assert("${res}" STREQUAL "@")

  set(asd 123)
  template_run("@asd")
  ans(res)
  assert("${res}" STREQUAL "123")

  function(test_fu a b)
    return("hello ${a} ${b}")
  endfunction()

  template_run("@test_fu(\"Tobias\" \"Becker\")")
  ans(res)
  assert("${res}" STREQUAL "hello Tobias Becker")


  template_run("<%% %%>")
  ans(res)
  assert("${res}" STREQUAL "<% %>")

  obj("{id:1,b:{c:3}}")
  ans(data)

  template_run("[<%={data.id}%>](<%={data.id}%>)")
  ans(res)
  assert("${res}" STREQUAL "[1](1)")

  template_run("
    Hello My Friend
    <% foreach(i RANGE 1 3) %><%=\${i}%><% endforeach() %>
    ByBy!
  ")
  ans(res)
  assert("${res}" STREQUAL "
    Hello My Friend
    123
    ByBy!
  ")


  ## tests wether the <%= expression works as expected

  template_run("<%={data.b.c}%>")
  ans(res)
  assert("${res}" STREQUAL "3")

  template_run("<%=abcdefg%>")
  ans(res)
  assert("${res}" STREQUAL abcdefg)

  set(input 123)
  template_run("<%=${input}%>")
  ans(res)
  assert("${res}" STREQUAL "123")

  ## spaces in string should be kep
  template_run("<%=\"  123  ${input}  \"%>")
  ans(res)
  assert("${res}" STREQUAL "  123  123  ")

  ## shoudl generate a list
  template_run("<%= 1 2 3%>")
  ans(res)
  assert(${res} EQUALS 1 2 3)



endfunction()