function(test)
  obj("{id:1,b:{c:3}}")
  ans(data)

  template_eval("[<%={data.id}%>](<%={data.id}%>)")
  ans(res)
  assert("${res}" STREQUAL "[1](1)")

  template_eval("
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

  template_eval("<%={data.b.c}%>")
  ans(res)
  assert("${res}" STREQUAL "3")

  template_eval("<%=abcdefg%>")
  ans(res)
  assert("${res}" STREQUAL abcdefg)

  set(input 123)
  template_eval("<%=${input}%>")
  ans(res)
  assert("${res}" STREQUAL "123")

  ## spaces in string should be kep
  template_eval("<%=\"  123  ${input}  \"%>")
  ans(res)
  assert("${res}" STREQUAL "  123  123  ")

  ## shoudl generate a list
  template_eval("<%= 1 2 3%>")
  ans(res)
  assert(${res} EQUALS 1 2 3)



endfunction()