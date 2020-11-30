#!/bin/bash
#written by Reza Sharifi (rsharifi210@gmail.com)

#LOCALIP=$(hostname -i)
hostname -I | tr " " "\n" > temporaryscript_1
tput setaf 4;cat << "EOF"

+-----------------------------------+
|                     	            |
|  Host & Domain check version 2.0  |
|       powered by GreenWeb©        |
+-----------------------------------+

  _____ _______       _____ _______ 
 / ____|__   __|/\   |  __ \__   __|
| (___    | |  /  \  | |__) | | |   
 \___ \   | | / /\ \ |  _  /  | |   
 ____) |  | |/ ____ \| | \ \  | |   
|_____/   |_/_/    \_\_|  \_\ |_|   
                                    

EOF

FILE=/etc/virtual/domains
if [ ! -f "$FILE" ]
then
	FILE=/etc/localdomains

	if [ ! -f "$FILE" ];then
	echo " error 404 , domain list file can't find! "
	tput setaf 9;
	exit 1;
	fi
fi

#recieve the last list of CDN ip ranges like cloudflare and etc.
curl https://www.cloudflare.com/ips-v4 >  .temp.iprange.txt 2>&1 > /dev/null
curl https://www.arvancloud.com/fa/ips.txt >> .temp.iprange.txt 2>&1 > /dev/null
curl http://5.9.201.73/ips.txt >> .temp.iprange.txt 2>&1 > /dev/null



tput setaf 6; echo "These domains resolve from another host : (please be patient) "
echo 
echo "These domains resolve from another host : " > Results.txt
echo "These domains use CDN : " > .temporaryscript_123
while IFS= read -r line
do
        # display $line or do somthing with $line
	DOMAINS=$(printf '%s\n' "$line")
	IP=$(ping -c 1 $DOMAINS | gawk -F'[()]' '/PING/{print $2}')
	#if [ "$IP" != "$LOCALIP" ]
	if !(grep -q $IP temporaryscript_1)
	then
		IPRANGE=$(echo $IP | awk -F. '{print $1 "." $2 "." $3  }');
		if grep -q $IPRANGE .temp.iprange.txt
		then
		echo $DOMAINS >>.temporaryscript_123	
		else
			tput setaf 2; echo $DOMAINS      '--------->'      $IP
			echo "$DOMAINS      '--------->'      $IP" >> Results.txt
		fi
	fi
	
done <"$FILE"

echo 
tput setaf 1;cat .temporaryscript_123
cat .temporaryscript_123 >> Results.txt
tput setaf 4; cat << "EOF"
 ______ _____ _   _ _____  _____ _    _ 
|  ____|_   _| \ | |_   _|/ ____| |  | |
| |__    | | |  \| | | | | (___ | |__| |
|  __|   | | | . ` | | |  \___ \|  __  |
| |     _| |_| |\  |_| |_ ____) | |  | |
|_|    |_____|_| \_|_____|_____/|_|  |_|
                                        
EOF
rm -f .temporaryscript_123 .temp.iprange.txt temporaryscript_1
tput setaf 9;
