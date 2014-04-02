# returns the var called ${ref}
# this inderection is needed when returning escaped string, else macro will evaluate the string
macro(return_ref ref)
  set(__ans "${${ref}}" PARENT_SCOPE)
endmacro()