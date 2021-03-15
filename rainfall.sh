#!/bin/bash
set -e 
weather_data="Rome:Jan 90.2,Feb 73.2,Mar 80.3,Apr 55.7,May 53.0,Jun 36.4,Jul 17.5,Aug 27.5,Sep 60.9,Oct 147.7,Nov 121.0,Dec 97.9
London:Jan 58.0,Feb 38.9,Mar 49.9,Apr 42.2,May 67.3,Jun 52.1,Jul 59.5,Aug 77.2,Sep 55.4,Oct 62.0,Nov 69.0,Dec 52.9
Paris:Jan 182.3,Feb 120.6,Mar 188.1,Apr 204.9,May 323.1,Jun 350.5,Jul 336.8,Aug 192.9,Sep 66.3,Oct 63.3,Nov 83.2,Dec 154.7
NY:Jan 128.7,Feb 121.8,Mar 151.9,Apr 93.5,May 98.8,Jun 93.6,Jul 142.2,Aug 131.8,Sep 92.0,Oct 82.3,Nov 107.8,Dec 94.2
Vancouver:Jan 155.7,Feb 121.4,Mar 132.3,Apr 69.2,May 85.8,Jun 47.1,Jul 31.3,Aug 37.0,Sep 69.6,Oct 116.3,Nov 154.6,Dec 171.5
Sydney:Jan 123.4,Feb 111.0,Mar 151.3,Apr 129.7,May 123.0,Jun 159.2,Jul 102.8,Aug 90.3,Sep 69.3,Oct 82.6,Nov 81.4,Dec 78.2
Bangkok:Jan 20.6,Feb 28.2,Mar 40.7,Apr 81.8,May 189.4,Jun 151.7,Jul 198.2,Aug 197.0,Sep 319.9,Oct 230.8,Nov 57.3,Dec 9.4
Tokyo:Jan 59.9,Feb 81.5,Mar 106.4,Apr 139.2,May 144.0,Jun 186.0,Jul 155.6,Aug 148.5,Sep 216.4,Oct 194.1,Nov 95.6,Dec 54.4
Beijing:Jan 13.9,Feb 14.7,Mar 18.2,Apr 18.4,May 43.0,Jun 88.1,Jul 224.3,Aug 170.0,Sep 58.4,Oct 38.0,Nov 19.3,Dec 2.7
Lima:Jan 11.2,Feb 10.9,Mar 10.7,Apr 10.4,May 10.6,Jun 11.8,Jul 14.4,Aug 13.1,Sep 23.3,Oct 1.7,Nov 0.5,Dec 10.7"

function mean () {
  data="$1"
  town="$2"
  numbers=$(echo $data | awk -F $town '{print $2}' | cut -d ':' -f2 | tr ',' '\n' | cut -d ' ' -f2)
  total=$(echo $numbers | tr ' ' '+' | bc)
  average=$(echo "$total/12" | bc -l)
  echo $average
}

# Take the sum of all squares from the difference of the mean
function variance () { 
  data=$1
  town=$2
  mean=$(mean "$data" "$town") 
  numbers=$(echo $data | awk -F $town '{print $2}' | cut -d ':' -f2 | tr ',' '\n' | cut -d ' ' -f2)
  running_sum=0

  for n in $numbers; do
    diff=$(echo "($n-$mean)*($n-$mean)" | bc -l)
    running_sum=$(echo "$running_sum+$diff" | bc -l)
  done;
  running_sum=$(echo "$running_sum/12" | bc -l)
  echo $town $running_sum
}

regions=$(echo $weather_data | tr -d ' ' | egrep '[a-zA-Z]*:' -o | cut -d ':' -f1)
for region in $regions; do
  variance "$weather_data" "$region"
done