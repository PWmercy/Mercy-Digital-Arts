#!/bin/bash

# v. 20180904.01
# As of 2018SP, no longer using ACLs because we are not limiting access to class

# This script reads a path and a data file, creates the folder structure for each class
# (main folder and 4 sub-folders), then sets permissions
# Parameters are (1) Path to class folders (2) data text file with list of classes and instructors

# EXAMPLE
# sudo sh /Users/sadmin/Desktop/Create-Class-Folders/Setclassfolderpermissions.sh
# /Volumes/Rack1HD2/MTEC-Classes
# /Users/sadmin/Desktop/Create-Class-Folders/2015SP-MTEC-classes.data


# PSEUDOCODE

# Read line
# Parse Class Name
# Posix permissions

# 1) Get path and data from user
read -p "Path to class folders: " path_to_Classes
read -p "Path to data: " path_to_Data

cd $path_to_Classes

while read instructor classNumber

# Sample line from data file
# jdoeteach    MUSI103DFA-Theory-Musicianship-I

do

  echo "HELLO"
  echo "$classNumber"
  echo "$instructor"
  ADinstructor="STUDENT\\"$instructor
  echo $ADinstructor
  class=`echo $classNumber | cut -d"-" -f1` #Strip characters after number, leaving e.g. MUSI103DFA
  echo $class

  # convert classnumber to lower case for OD group name, e.g. musi103dfa
  classGroupName=`echo $class | tr  '[:upper:]' '[:lower:]'`
  echo $classGroupName
  mkdir $classNumber

  # Give instructor R/W
#  chown "$ADinstructor" $classNumber
 # chgrp administrators $classNumber

  # Give students read only
  chmod 755 $classNumber

  # Remove read permissions from Others, leaving no access
  #chmod o-r $classNumber

  # cd to this new class folder then create sub-folders

  cd $classNumber

  folder="Pick-up-here"
  dir=$class-$folder
  echo $dir
  mkdir $dir

  folder="Drop-off-here"
  dir=$class-$folder
  echo $dir
  mkdir $dir
  echo $dir
  # Others to Write Only --> dropbox
  chmod o-r+w $dir

  folder="Instructor-only"
  dir=$class-$folder
  echo $dir
  mkdir $dir
  # Remove class ACL so only Instructor can open
  chmod o-rw $dir

  folder="Collaboration"
  dir=$class-$folder
  echo $dir
  mkdir $dir
  # Remove class ACL then add back with R/W
  chmod o+rw $dir

  cd ..
chown -R "$ADinstructor" $classNumber
 chgrp -R administrators $classNumber
done < $path_to_Data
