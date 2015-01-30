
# contains common regular expression 
macro(regex_uri)

    set(lowalpha "[a-z]")
    set(upalpha "[A-Z]")
    set(digit "[0-9]")
    set(alpha "(${lowalpha}|${upalpha})")
    set(alphanum "(${alpha}|${digit})")

    set(reserved "[\;\\/\\?:@&=\\+\\$,]")
    set(reserved_no_slash "[\;\\?:@&=\\+\\$,]")
    set(mark "[\\-_\\.!~\\*'\\(\\)]")
    set(unreserved "(${alphanum}|${mark})")
    set(hex "[0-9A-Fa-f]")
    set(escaped "%${hex}${hex}")


    #set(uric "(${reserved}|${unreserved}|${escaped})")
    set(uric "[^ ]")
    set(uric_so_slash "${unreserved}|${reserved_no_slash}|${escaped}")


    set(scheme_regex "((${alpha})(${alpha}|${digit}|[\\+\\-\\.])*)")
    set(net_root_regex "//")
    set(abs_root_regex "/")

    set(abs_path "\\/${path_segments}")
    set(net_path "\\/\\/${authority}(${abs_path})?")
    
    set(authority_char "([^/\\?#])" )
    set(authority_regex "${authority_char}+")

    set(segment_char "[^\\?#/ ]")
    set(segment_separator_char "/")


    set(path_char_regex "[^\\?#]")
    set(query_char_regex "[^#]")
    set(query_regex "\\?${query_char_regex}*")
    set(fragment_char_regex "[^ ]")
    set(fragment_regex "#${fragment_char_regex}*")

#  ";" | ":" | "&" | "=" | "+" | "$" | "," 
    set(dns_user_info_char "(${unreserved}|${escaped}|[;:&=+$,])")
    set(dns_user_info_separator "@")
    set(dns_user_info_regex "(${dns_user_info_char}+)${dns_user_info_separator}")

    set(dns_port_seperator :)
    set(dns_port_regex "[0-9]+")
    set(dns_host_regex_char "[^:]")
    set(dns_host_regex "(${dns_host_regex_char}+)${dns_port_seperator}?")
      set(dns_domain_toplabel_regex "${alpha}(${alphanum}|\\-)*")
      set(dns_domain_label_separator "[.]")
    set(dns_domain_label_regex "[^.]+")
    set(ipv4_group_regex "(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9][0-9]|[0-9])")
    set(ipv4_regex "${ipv4_group_regex}[\\.]${ipv4_group_regex}[\\.]${ipv4_group_regex}[\\.]${ipv4_group_regex}")
endmacro()