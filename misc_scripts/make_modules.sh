#!/bin/bash

# 1. This script will upload 3 files to the server first (at your /tmp/compile/<yourname>/module ):
#	- the .c file
#	- the Makefile (it will creat for you)
#	- script to compile at server side
# 2. Then, it will SSH into the server, run the script to compile and make .ko file
# 3. Once again, SFTP into the server and get the .ko file

#MAKE SURE TO CHANGE THE PATHS FOR THE SCRIPT TO GO TO YOUR DIRECTORY!

if [ $# -ne 1 ] ; then
	echo "USAGE : $0 <c-file>"
	exit 0
fi



HOST="linuxlab006.seas.wustl.edu"
USER="" #wustlid
PASS="" # your password <keep it secret .-."
FILE=$1

#create Makefile for compilation

FILE_COMP=$(echo $FILE  | cut -f1 -d '.')
touch Makefile
echo "obj-m := "$FILE_COMP".o " > Makefile


#create compile script
touch build_module_in_server.sh
echo "#!/bin/bash" >> build_module_in_server.sh
echo "module add raspberry" >> build_module_in_server.sh
echo "KERNEL=kernel7" >> build_module_in_server.sh
echo "LINUX_SOURCE=../linux_source/linux" >> build_module_in_server.sh
echo "make -C $LINUX_SOURCE ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- SUBDIRS=$PWD modules" >> build_module_in_server.sh

#send c and Makefile file to be compiled at the linux server

expect -c "

spawn sftp ${USER}@${HOST}
expect \"itavares@linuxlab006.seas.wustl.edu's password: \"
send \"${PASS}\r\"
expect \"sftp>\"
send \" ls\r \"
expect \"sftp> \"
send \" cd /tmp/compile/ighor.tavares/module\r\"
expect \"sftp> \"
send \" ls\r \"
expect \"sftp> \"
send \" put Makefile\r \"
expect \"sftp> \"
send \" put build_module_in_server.sh\r \"
expect \"sftp> \"
send \" put ${FILE}\r \"
sleep 1
expect \"sftp> \"
send \" bye \r \"
expect eof

" 
echo " " 
echo "Done uploading to server........."
# Now we SSH into and compile the thing...yay
# we are running a seperate script because of execpt shell
#./compile_ssh.sh

expect -c "

spawn ssh ${USER}@${HOST} \"cd /tmp/compile/ighor.tavares/module; ls ; chmod +x build_module_in_server.sh ; ./build_module_in_server.sh ; exit \"
expect \"itavares@linuxlab006.seas.wustl.edu's password: \"
send \"${PASS}\r\"
interact

"

sleep 2
echo " "
echo " Done compiling module on the server....."


expect -c "
spawn sftp ${USER}@${HOST}
expect \"itavares@linuxlab006.seas.wustl.edu's password: \"
send \"${PASS}\r\"
expect \"sftp>\"
send \" cd /tmp/compile/ighor.tavares/module\r\"
sleep 1
expect \"sftp>\"  
send \" ls \r \"
expect \"sftp>\"
sleep 2
send \" get ${FILE_COMP}.ko \r \"
sleep 1
expect \"sftp>\"
send \"bye\r\"
"


echo ""
echo " FINSIHED! "
