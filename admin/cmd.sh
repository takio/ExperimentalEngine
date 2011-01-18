#!/bin/bash

case $1 in
  "style" )
    astyle --style=allman --suffix="" --formatted --mode=java --indent=spaces=2 src/*.cpp
    mv src/*.orig src/.backup/
  ;;
  "doc" )
      version=$(cat src/version.h | grep "FULLVERSION_STRING" | sed -e "/FULLVERSION_STRING/ s/[a-zA-Z ]*FULLVERSION_STRING\[\] = \"\(.*\)\";/\1/p" | head -n 1 | sed -e "s/\t//g")
      title=$(cat ExperimentalEngine.cbp | grep "<Option title=\"" | sed -e "s/\t//g" -e "s/<Option title=\"\(.*\)\" \/>/\1/g")
      cat admin/Doxyfile | sed -e "/PROJECT_NUMBER/ s/\(PROJECT_NUMBER *=\)\(.*\)/\1 $version/g" > admin/Doxyfile.tmp
      mv admin/Doxyfile.tmp admin/Doxyfile
      cat admin/Doxyfile | sed -e "/PROJECT_NAME/ s/\(PROJECT_NAME *=\)\(.*\)/\1 $title/g" > admin/Doxyfile.tmp
      mv admin/Doxyfile.tmp admin/Doxyfile
      cd src/ ; doxygen ../admin/Doxyfile 2> ../admin/Doxygen.err.log > ../admin/Doxygen.out.log
      cd ..
      mv doc/html .
      rm -rf doc/
      mv html doc
    ;;
esac
