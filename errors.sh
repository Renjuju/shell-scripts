#!/bin/zsh


success=0
function throwsSomeError () {
  # cat /someDirectoryThatDoesntExist || return 1
  success=1
}

{ 
  throwsSomeError
  echo $success
  if [[ $success -eq 1 ]]; then
    echo "Success";
  else
    echo "Failure";
  fi
}  
