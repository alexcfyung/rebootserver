#!/bin/bash

if [ $# -lt 1 ]
then
	echo 'Error: Missing command option' >&2
	exit 1
fi

if [ $1 = reboot ]
then
	if [ $# -eq 1 ]
	then
		echo 'Error: Please enter target server number, * for all' >&2
		exit 1
	elif [ $# -eq 2 ]
	then
		if [ $2 = '*' ]
		then
			while IFS= read -r server <&3; do
				ssh $server shutdown -r now
			done 3<./list_of_servers.txt
			exit 0
		else
			re='^[0-9]+$'
			if [[ ! $2 =~ $re ]]
			then
			   echo "Error: Please enter a number" >&2
			   exit 1
			fi
			
			count=0
			while IFS= read -r server <&3; do
				if [ $count -eq $2 ]
				then
					ssh $server shutdown -r now
					exit 0
				fi
				count=$count+1
			done 3<./list_of_servers.txt
			echo "Error: The number $2 does not correspond to any server"
			exit 1
		fi
	else
		c=0
		for arg in "$@"
		do
			if [[ $c >= 2 ]]
			then
				re='^[0-9]+$'
				if [[ ! $arg =~ $re ]]
				then
				   echo "Error: $arg is not a number" >&2
				else
					count=0
					while IFS= read -r server <&3; do
						if [ $count -eq arg ]
						then
							ssh $server shutdown -r now
							exit 0
						fi
						count=$count+1
					done 3<./list_of_servers.txt
				fi
			fi
			c=$c+1
		done
	fi
elif [ $1 = status ]
then
	count=0
	while IFS= read -r server <&3; do
		ping -c 3 $server > /dev/null 2>&1
		if [ $? -ne 0 ]
		then
			echo "$count $server alive"
		else
			echo "$count $server dead"
		fi	
		count=$count+1
	done 3<./list_of_servers.txt
else
	echo "Error: Unrecognized option $1" >&2
fi
