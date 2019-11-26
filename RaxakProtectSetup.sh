#!/bin/bash
#	VMSetup.sh
#	(c) 2015-2018, Cloud Raxak, Inc.
#	This script, run as a post-install script, will set up the desired userid
#	and populate its public key. It will also set up no-password sudo access
#	and the !requiretty flags in the sudoers file
#   Usage: VMSetup.sh <userid>
#       where <userid> defaults to "raxak" if not specified
#
#-----------------------
#	We assume that the script is running as root
#   Output from the file can usually be found in /var/log
#
echo ${0}" VM setup script. (c) 2014-2018 Cloud Raxak Inc."
#
# randpw(){ < /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-16};echo;}

if [ "$(id -u)" != "0" ]; then
   echo ${0}" must be run as root."
   exit 1
fi

#    Global variables and overrides go here
#***
username='raxak'
raxakserver='https://raxakprotect.cloudraxak.net'
resource_type='29'
org='14702'
owner='14705'
selected_profile='[rpm-based Linux] CIS Profile (Subset)'
selected_profile_id='5841'
compliance_mode='remediate'
ssh_port='22'
compliance_freq="daily"

username=${username:-raxak}
resource_type=${resource_type:-None}
# Searching Port from ssh config file
ssh_port=${ssh_port:-22}
if grep -Ew '(\s*Port)|(#Port)' /etc/ssh/sshd_config >> /dev/null; then
ssh_port=`grep -Ew '(\s*Port)|(#Port)' /etc/ssh/sshd_config | awk '{print $2;}'`
fi

#   Check if all basic tools are available (wget and Python)
if [ ! -x /usr/bin/wget ]; then
    echo "*** wget is not available -- Installing"
    if [ -f /etc/lsb-release -o -f /etc/debian_version ]; then
          sudo apt-get -y install wget
          if [ $? -eq 0 -a -x /usr/bin/wget ]; then
				echo "*** wget successfully installed"
          else
                echo "*** wget:Install error hence unable to enroll, please contact the RAXAK administrator for further assistance."
                exit 1
          fi
    else
          sudo yum install -y wget
          if [ $? -eq 0 -a -x /usr/bin/wget ]; then
                echo "*** wget successfully installed"
          else
                echo "*** wget:Install error hence unable to enroll, please contact the RAXAK administrator for further assistance."
                exit 1
          fi
    fi
fi

python=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
if [ -z "$python" ]; then
    echo "*** Python is not installed -- Installing"
    if [ -f /etc/lsb-release -o -f /etc/debian_version ]; then
        sudo apt-get -y install python
        python=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
        if [ -z "$python" ]; then
		    echo "*** Could not install Python. Please contact the Raxak administrator for further assistance."
		    exit 1
        else
            echo "*** Python installed"
        fi
    else
        sudo yum install -y python
        python=$(python -V 2>&1 | grep -Po '(?<=Python )(.+)')
        if [ -z "$python" ]; then
		    echo "*** Could not install Python. Please contact the Raxak administrator for further assistance."
		    exit 1
        else
            echo "*** Python installed"
        fi
    fi
fi


# Calling the test connection validation script
raxakserver=${raxakserver:-https://softlayer.cloudraxak.net}
test_url=$raxakserver"/test_connection/"

echo "API Call: "$test_url
echo "****************************************"
test=$(wget -qO- --no-check-certificate "$test_url")
if [ `echo $test | grep -c "Congratulations!!"` -gt 0 ]; then
    echo -e "$test"
    echo "****************************************"
    echo "*******Enrolling the Server*************"
    echo "****************************************"
else
    echo "Connectivity Validation Script FAILED!! Hence, exiting from Enrollment!!"
    echo "****************************************"
    exit 1
fi


echo Working as user `whoami`
id -u $username
result=$?;
if [ $result -ne 0 ]; then
echo "Create user "$username
echo 'Creating username '$username
useradd -m $username
fi
echo 'User '$username' exists -- checking sudo ability created by Cloud Raxak'
if grep -i "Added for Raxak Protect service" /etc/sudoers; then
   echo 'sudoers file has already been updated'
else
echo '# Added for Raxak Protect service' >> /etc/sudoers
echo 'Defaults:'$username' !requiretty'  >> /etc/sudoers
echo 'Defaults:root !requiretty'         >> /etc/sudoers
echo $username' ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
echo '# End section ---   Raxak Protect' >> /etc/sudoers
fi

echo 'Switching to '$username
su - $username << "EOF"
echo User changed to `whoami`
cd ~
echo Working in directory `pwd`
mkdir -p ~/.ssh/
key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDnn15vePUUwc655qz07QXBrrxbu8Qe0vze1WyEf5k3fDhWcNRVhpJZoyFxWn5KHAtUSUKliHLM6r2wZ5N3CsswMvfwbfr1qt4iHZViMZsZLQfvjzb7XHA04Vl/+SQDi7DEVGEAlV+JMeA1gLYwhMn6OCXwdmOV4g4Pze8fPV801XU+X55wM81WHSis3h9lfvrBJdH+S1GbC3RyXieoVIzXmt4lJN1kB2ZjOZdo10UDVMF6jXfUhAtombEUE5ZyaVoPZi9vXEDSN+mJwHt6ok6mJwTI80bGFGmpJfqqSjJ2HGJZN4ONYFMyrdgMgyDyf0Yk1lq7/41LSC2Kb+6HCDor raxak:2fe93903-daa5-4e23-afc2-4090aac3c102:14702
"
echo "Key = "$key
# Parse the raxak server GUID and org name from the key
set $key
if [ $# -ge 3 ]; then
    IFS=':'
    set -- $3
    comment=$1":"$2
fi

echo "Removing any key matching "$comment
# Remove any old raxak key that may exist in the list and matches the comment
touch ~/.ssh/authorized_keys
sed -i.bak "s/.*$comment.*//g" ~/.ssh/authorized_keys
sed -i.bak "/^\s*$/d" ~/.ssh/authorized_keys  # Remove any blank lines left over from previous sed
# Replace key with active public key in ~/.ssh/raxak-key.pub (customize function)
echo "$key" >> ~/.ssh/authorized_keys
echo ""     >> ~/.ssh/authorized_keys
chmod 640 ~/.ssh/authorized_keys
chmod 700 ~/.ssh/

# Checking if resource is created in Azure
vmurl='http://169.254.169.254/metadata/instance?api-version=2017-08-01'
vmget=$(wget --header "Metadata:"true"" --timeout=10 --tries=1 -qO- --no-check-certificate "$vmurl")
guid=$(echo $vmget | sed -n 's/^.*vmId" "\s*\(\S*\).*","vmSize.*$/\1/p')

# create and store a guid for this machine if one does not exist already
if [ ! -f .raxakguid ]; then
    echo "Creating a new GUID for the server"
    if [ -n "$guid" ]; then
        echo $guid > .raxakguid
    else
        echo `uuidgen` > .raxakguid
    fi
    chmod 600 .raxakguid
else
    echo "GUID file exists for this server"
    echo "GUID = "`cat .raxakguid`
fi


EOF

#!/bin/bash
# This is the stub file that is  used by the createCustomVMSetup API call
#   to construct a custom VMSetup.sh
#   This section must run as root
#   $username should be defined externally
#
# Create hidden file with customization
#   This file is created as a hidden file with root access only

# Verifying instalation of python

echo "Customization section: (c) Cloud Raxak Inc."
username=${username:-raxak}
#
# Now create the autoenroll capability
#
hostname=`hostname`
# check the guid of machine
# Changed by prasanna to use guid in the .raxakguid file
# crguid=`cat /proc/sys/kernel/random/boot_id`
if [ ! -f /home/$username/.raxakguid ];then
    echo "Creating a new GUID for the server"
    echo `uuidgen` > /home/$username/.raxakguid
    chmod 600 /home/$username/.raxakguid
    chown $username:$username /home/$username/.raxakguid
fi
crguid=`cat /home/$username/.raxakguid`
arch=`arch`
#Find the resource version
echo "Username: "$username
echo "Host name: "$hostname
echo "GUID: "$crguid
echo "OWNER: "$owner
echo "selected_profie": "$selected_profile"
echo "selected_profie": "$selected_profile_id"
echo "compliance_mode": "$compliance_mode"
echo "compliance_freq": "$compliance_freq"

# syntax: /raxakapi/hostname/username/profile/auto/repeat/resource_type/crguid/version/ssh_port/arch/org
#   defaults: 
#   username = "raxak" (set globally here)
#   hostname = hostname of the server
#   Resource_type = 28 (Type of the resource)
#   cr_guid = Unique machien identifier
#   Arch = 64 (System Architecture , either 64-bit or 32-bit)
#   Org = 231 (Unique ID os the organization)
#


echo "Raxak SaaS server: "$raxakserver

# Checking if resource is created in Azure
vmurl='http://169.254.169.254/metadata/instance?api-version=2017-08-01'
vmget=$(wget --header "Metadata:"true"" --timeout=10 --tries=1 -qO- --no-check-certificate "$vmurl")
vmid=$(echo $vmget | sed -n 's/^.*vmId":"\s*\(\S*\).*","vmSize.*$/\1/p')

enroll=$raxakserver"/autoenroll/"$hostname"/"$username"/"$selected_profile_id"/"$compliance_mode"/"$compliance_freq"/"$resource_type"/"$crguid"/"$ssh_port"/"$arch"/"$org"/"$owner"/"
azureuri=$raxakserver"/Enroll_Azure_VM/000/None/None/None/None/"$vmid"/"

echo "API Call: "$enroll

echo "Using wget -q "$enroll" -O /dev/null"
echo "****************************************"
result=$(wget -qO- --no-check-certificate "$enroll")
if [ "$result" == "Congrats! Machine is successfully enrolled!" ] && [ -n $vmid ] ; then
    vmup=$(wget -qO- --no-check-certificate "$azureuri")
fi
echo $result
echo "****************************************"

rm -f stack
exit

