#!/bin/zsh

#IFS=$'\n';
data="01|15|59, 1|47|16, 01|17|20, 1|32|34, 2|17|17";
# "Range: 01|01|18 Average: 01|38|05 Median: 01|32|34"

## Convert everything to seconds
## Calculate range, average, and median
## Convert back to hours| minutes | seconds

function stat () {
  data=$1
  stats=$(for d in $(echo $data); do echo $d | tr -d ','; done;)
  seconds=()
  for stat in $(echo $stats); do
    hour=$(echo $stat | cut -d '|' -f1);
    minute=$(echo $stat | cut -d '|' -f2);
    second=$(echo $stat | cut -d '|' -f3)
    total_seconds=$((hour*60*60 + minute*60 +  second))
    seconds+=("$total_seconds")
  done

  range=$(get_range "$seconds" | convert_to_str);
  mean=$(get_mean "$seconds"  | convert_to_str);
  median=$(get_median "${seconds[@]}" | convert_to_str);

  echo "Range: $range Average: $mean Median: $median";
}

function get_median () {
  timings=("$@")
  IFS=$'\n'; 
  sorted=($(sort -n <<< "${timings[*]}")); 
  len="${#sorted[@]}";
  if [[ $((len % 2)) -eq 1 ]]; then
    len=$((len + 1))
  fi
  middle=$((len / 2));
  tail -1 <<< $(head -n $middle <<< "${sorted[*]}")
  unset IFS;
}

function get_mean () {
  timings=$1
  count=0
  sum=0
  for t in $(echo $timings); do
    sum=$((sum + t))
    count=$((count + 1))
  done;
  echo $((sum/count))
}

function get_range () {
  timings=$1
  max='';
  min='';

  for t in $(echo $timings); do
    if [[ -z $max && -z $min ]]; then
      max=$t
      min=$t
    fi 

    if [[ $t -gt $max ]]; then
      max=$t
    fi

    if [[ $t -lt $min ]]; then
      min=$t
    fi

  done;

  echo $((max-min))
}

function convert_to_str () {
  hours=0;
  minutes=0;
  local seconds
  read seconds 
  while [[ $seconds -gt 3600 ]]; do
		seconds=$((seconds - 3600))
    hours=$((hours + 1))
  done;

  while [[ $seconds -gt 60 ]]; do
		seconds=$((seconds - 60 ))
    minutes=$((minutes + 1))
	done;

  echo "$hours|$minutes|$seconds";
}

stat "$data"
