#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then
echo -e "Please provide an element as an argument."
else
if [[ $1 =~ ^[0-9]*$ ]]
then
atomic_number=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
  if [[ $atomic_number ]]
  then
  number=$atomic_number
  fi
fi

if [[ $1 =~ ^[A-Z][a-z]*$ ]]
then
symbol=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1'")
  if [[ $symbol ]]
  then
  number=$symbol
  fi
fi

if [[ $1 =~ ^[A-Z][a-z]+$ ]]
then
name=$($PSQL "SELECT atomic_number FROM elements WHERE name='$1'")
  if [[ $name ]]
  then
  number=$name
  fi
fi

if [[ -z $atomic_number && -z $symbol && -z $name ]]
then
  echo I could not find that element in the database.
else
 
  element=$($PSQL "SELECT name FROM elements WHERE atomic_number='$number'")
  sym=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$number'")
  type=$($PSQL "SELECT type FROM types LEFT JOIN properties USING(type_id) WHERE atomic_number='$number'")
  mass=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$number'")
  mp=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$number'")
  bp=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$number'")
  echo "The element with atomic number $number is $element ($sym). It's a $type, with a mass of $mass amu. $element has a melting point of $mp celsius and a boiling point of $bp celsius."

fi
fi
