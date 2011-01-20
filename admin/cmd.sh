#!/bin/bash

srcdir="src/"
srcs=$srcdir*.cpp

case $1 in
  "style" )
    astyle --style=allman --suffix="" --formatted --mode=java --indent=spaces=2 $srcs 2> admin/astyle.err.log > admin/astyle.out.log
    if [ -e $srcdir/*.orig ]; then
      mkdir -p $srcdir/.backup
      mv $srcdir/*.orig $srcdir/.backup/
    fi
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
  "clean" )
    rm -rf doc/ obj/ bin/ admin/*.log build/
  ;;
  "check" )
    cppcheck --enable=all --verbose $srcs --xml 2> admin/cppcheck.err.xml.log > admin/cppcheck.out.xml.log
  ;;
  "build" )
    if [ -d build ];
    then
      rm -rf build/
    fi
    mkdir -p build
    cd build
    cmake ..
    make
  ;;
  "execute"  | "exec" )
    if [ -d build ];
    then
      build/src/xengine
    fi
  ;;
esac
