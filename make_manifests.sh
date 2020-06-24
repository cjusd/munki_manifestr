#!/bin/bash

	filename="$1"
	manifest=${2:-_staff-common}
	lines=0
	counter_new=0
	counter_exists=0

if [ "$manifest" == "_staff-common" ]; then
	echo "You have not supplied a manifest name and"
	echo "will be using the default of: $manifest."
	read -p "Are you sure? (y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		if [ -f "$filename" ]; then
			mkdir -p manifests
			while read -r serial; do
				serial=$( echo "$serial" | cut -d, -f1 | tr -d \" )
				file=manifests/"$serial"
				if [ "$lines" -gt 0 ]; then
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
						echo "		<string>$manifest</string>" >> $file
						echo "	</array>" >> $file
						echo "	</dict>" >> $file
						echo "</plist>" >> $file
						counter_new=$[$counter_new +1]
					fi
				fi
				echo -ne "-"
				lines=$[$lines +1]
			done < "$filename"
			echo
			echo "Read $lines lines from $filename"
			echo "Wrote $counter_new new manifests, $counter_exists manifests already existed"
			echo "These manifest files can be copied into the manifest directory in your Munki repo."
		else
			echo "Usage:"
		  echo "   Please enter a valid Device Assignment file downloaded from school.apple.com"
		  echo ""
		  echo "   For example: "
		  echo "                generate_manifests.sh serials.csv"
		  echo ""
		  echo "   Where 'serials.csv' is a Device Assignment file downloaded from school.apple.com"
		  exit 1
		fi
	else
		exit 0
	fi
fi