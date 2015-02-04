#!/bin/bash
wget https://raw.github.com/toeb/cmakepp/${TRAVIS_COMMIT}/install.cmake && cmake -P install.cmake && rm install.cmake && source ~/.bashrc