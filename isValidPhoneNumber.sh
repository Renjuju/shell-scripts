#!/bin/bash
echo $1

regex='^\([0-9]{3}\) [0-9]{3}-[0-9]{4}$'
[[ $1 =~ $regex ]] && echo True || echo False
