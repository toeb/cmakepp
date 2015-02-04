((new-object net.webclient).DownloadString('https://raw.github.com/toeb/cmakepp/master/install.cmake')) |`
out-file -Encoding ascii install.cmake; `
cmake -P install.cmake; `
rm install.cmake;

