function(test)


  svn_uri_analyze("https://github.com/toeb/test_repo/trunk/asdbsd/sd" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo@2")
  svn_uri_analyze("https://github.com/toeb/test_repo" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo@2" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo/trunk" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo/branches/b1" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo/tags/b1" --revision 3)
  svn_uri_analyze("https://github.com/toeb/test_repo/tags/b1" --revision 3 --tag asd)

endfunction()