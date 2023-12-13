#!/bin/bash
#-------------------------------------------------------------------------#
#	Edited by Peter Karlsson; Date 12 May 2023
#	Editing information: Added gfortran flag "-mcmodel=medium" because build failed.
#			     Probable cause is memory allocated by talys 
#			     for file name too large.
#-------------------------------------------------------------------------#
unalias -a
echo
echo "       code_build (Version February 20 2023) (C) Copyright 2023 Arjan Koning All Rights Reserved"
echo
if [ $# -ne 1 ] ; then
  echo 'Code name required'
  echo 'e.g. code_build talys'
  exit
fi
code=$1
#
# Script for fortran code installation on Linux and MacOS.
# Adapt the following compilation variables.
#
FC='gfortran -mcmodel=medium'
FFLAGS='-w'
#
# Basic installation (verified with the sample cases)
#
# FC="gfortran " FFLAGS=" "
#
# Distribution FC & FFLAGS (options provided by J-C Sublet)
#
# FC="gfortran " FFLAGS=" -Ofast "
# FC="ifort    " FFLAGS=" -Ofast "
# FC="nagfor   " FFLAGS=" -w     "
#
# Development FC & FFLAGS  (options provided by J-C Sublet)
#
# FC="gfortran " FFLAGS=" -Wall -fcheck=all -Og -g -fbacktrace   "
# FC="ifort    " FFLAGS=" -O0 -g -traceback -check all -debug all"
# FC="nagfor   " FFLAGS=" -C=all -O0 -g -gline                   "
#
#
# Set directories
#
cwd=`pwd`'/'
sourcedir=${cwd}'source/'
bindir=${cwd}'talys_bin'
cd $sourcedir
if [ $code != endftables ] && [ $code != sacs ] ; then
  ../path_change
fi
#
# Clean up previous .o and .mod files and compile code.
#
echo "Compiling ${code}...."
ls *.o > /dev/null 2>&1
if [ $? -eq 0 ] ;then
  rm *.o
fi
ls *.mod > /dev/null 2>&1
if [ $? -eq 0 ] ;then
  rm *.mod
fi
ls *.f > /dev/null 2>&1
if [ $? -eq 0 ] ;then
  ${FC} ${FFLAGS} -c *.f
fi
ls *.f90 > /dev/null 2>&1
if [ $? -eq 0 ] ;then
  ${FC} ${FFLAGS} -c *.f90
fi
${FC} ${FFLAGS} *.o -o ${code}
#
# Check whether the build procedure has been successful
#
if [ -e $code ] ; then
  mkdir -p ${bindir}
  mv -f $code ${bindir}/$code
  echo ' '
  echo 'The '${code}' build has been completed.'
  echo ' '
  echo 'The '${code}' executable is in the ' $bindir 'directory.'
  echo ' '
else
  echo ${code} 'build failed'
fi
