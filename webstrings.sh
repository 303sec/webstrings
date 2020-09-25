#!/bin/bash

if [ $# -eq 0 ]
  then
      echo "No arguments supplied"
      exit
  fi


curl $1 | shift-query 'IdentifierExpression, LiteralStringExpression' | tail -n+2 | jq -r '.[] | .value, .name' | grep -v '^null$' | sed '/^.\{,3\}$/d' | awk '!x[$0]++'
# shift-query translates the JS into AST nodes - https://jsoverson.github.io/shift-query-demo/ and we select IdentifierExpressions, which are variable / function names, and LiteralStringExpressions, which are all strings
# tail because shift-query returns bool before JSON
# using jq to select all values from LiteralStrings and names from IdentifierExpressions
# grep away all lines that only say null because this is easier than me learning jq properly
# sed to remove any lines with less than 3 characters.
# this cool awk one liner (awk '!x[$0]++') puts the file into memory and only returns unique lines without sorting it alphabetically
# because it stores it in memory I'd advise against opening 2GB files
