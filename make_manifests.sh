#!/bin/bash

filename="$1"
lines=0
counter_new=0
counter_exists=0

if [ -f "$filename" ]; then
	mkdir -p manifests
	while read -r serial
	do
		lines=$[$lines +1]
		file=manifests/"$serial"
	  if [ -e "$file" ]; then
			counter_exists=$[$counter_exists +1]
	  else
		  echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> $file
			echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $file
			echo "<plist version=\"1.0\">" >> $file
			echo "	<dict>" >> $file
			echo "	<key>catalogs</key>" >> $file
			echo "	<array>" >> $file
			echo "		<string>production</string>" >> $file
			echo "	</array>" >> $file
			echo "	<key>display_name</key>" >> $file
			echo -n "	<string>" >> manifests/"$serial"
			echo -n $serial >> manifests/"$serial"
		  echo "</string>" >> $file
			echo "	<key>included_manifests</key>" >> $file
			echo "	<array>" >> $file
			echo "		<string>_staff-common</string>" >> $file
			echo "	</array>" >> $file
			echo "	</dict>" >> $file
			echo "</plist>" >> $file
			# echo "Wrote manifest file to manifests/$serial"
			counter_new=$[$counter_new +1]
		fi
	done < "$filename"
	echo "Read $lines lines from $filename"
	echo "Wrote $counter_new new manifests, $counter_exists manifests already existed"
else
	echo "Usage:"
  echo "   Please enter a valid file containing a list of serial numbers, one per line."
  echo ""
  echo "   For example: "
  echo "                generate_manifests.sh serials.csv"
  echo ""
  echo "   Where 'serials.csv' is a file containing a list of serial numbers, one per line."
  exit 1
fi