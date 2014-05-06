function(test)

map()
  kv("heloo" "youuu")
  val("asd")
  map("wooot")
kv("heloo" "youuu")
  val("asd")
  
  end()
end()
ans(res)


qm_serialize(${res})
ans(res)

qm_deserialize(${res})

ans(res)

message("${res}")
endfunction()