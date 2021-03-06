#!/bin/bash

currentUser=$1
newUser=$2

if [ $# -lt 2 ]; then
        printf "Usage:\n\t$0 <current_username> <new_username> [new_home_dir_path]\n"
        exit 1
fi

if [ $(id -u) -ne 0 ];then
        echo "Root permission needed for modifying users. Can not continue."
        exit 2
fi

newHome="/home/$newUser"
if [ $# == 3 ];then
        newHome=$3
fi

echo "Changing $currentUser to $newUser"
echo
echo "Running this script has the possibility to break sudo (sudoers file(s)) and WILL kill all processes owned by $currentUser"
echo "$currentUser will be logged out and will need to reconnect as $newUser"
read -n1 -s -r -p $'Continue [Y/n]?\n' key

if [ $key != '' -a $key != 'y' -a $key != 'Y' ]; then
        echo "Stopping; no files changed"
        exit 2
fi


# put the main script in /tmp so the user's home directory can be safely moved
tmpFile=$(mktemp)
cat > $tmpFile << EOF
#!/bin/bash
shopt -s extglob

# terminate (nicely) any process owned by $currentUser
ps -o pid= -u $currentUser | xargs -r kill
# wait for all processes to terminate
sleep 2
# forcibly kill any processes that have not already terminated
ps -o pid= -u $currentUser | xargs -r kill -s KILL


# change the user's username
usermod -l "$newUser" "$currentUser"
# move the user's home directory
usermod -d "$newHome" -m "$newUser"
# change user's group name
groupmod -n "$newUser" "$currentUser"
# replace username in all sudoers files
sed -i.bak 's/'$currentUser'/'$newUser'/g' /etc/sudoers
for f in /etc/sudoers.d/!(*.bak); do
  echo "editing '\$f'"
  sed -i.bak 's/'$currentUser'/'$newUser'/g' \$f
  # TODO fix $f not getting the file path for some reason
done
EOF

echo "Putting script into $tmpFile and running"
chmod 777 $tmpFile
sudo -s -- bash -c "nohup $tmpFile >/dev/null &"
