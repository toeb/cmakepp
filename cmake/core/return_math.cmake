
  macro(return_math expr)
    math(EXPR res "${expr}")
    return(${res})
  endmacro()
