#!/bin/bash

apt update

apt-get install openssh-server -y

cp /etc/ssh/sshd_config  /etc/ssh/sshd_config.backup

echo "Please enter the desired SSH port"
read portssh


# Config for SSH server
# Variables

file="$1"
param[1]="PermitRootLogin "
param[2]="PubkeyAuthentication"
param[3]="X11Forwarding "
param[4]="PasswordAuthentication"
param[5]="Port"

# Functions
usage(){
  cat << EOF
    usage: $0 ARG1
    ARG1 Name of the sshd_config file to edit.
    In case ARG1 is empty, /etc/ssh/sshd_config will be used as default.

    Description:
    This script sets certain parameters in /etc/ssh/sshd_config.
    It's not production ready and only used for training purposes.

    What should it do?
    * Check whether a /etc/ssh/sshd_config file exists
    * Create a backup of this file
    * Edit the file to set certain parameters
EOF
}

backup_sshd_config(){
  if [ -f ${file} ]
  then
    cp ${file} ${file}.1
  else
    echo "File ${file} not found."
    exit 1
  fi
}

edit_sshd_config(){
  for PARAM in ${param[@]}
  do
    sed -i '/^'"${PARAM}"'/d' ${file}
    echo "All lines beginning with '${PARAM}' were deleted from ${file}."
  done
  echo "${param[1]} yes" >> ${file}
  echo "'${param[1]} yes' was added to ${file}."
  echo "${param[2]} no" >> ${file}
  echo "'${param[2]} no' was added to ${file}."
  echo "${param[3]} yes" >> ${file}
  echo "'${param[3]} yes' was added to ${file}."
  echo "${param[4]} yes" >> ${file}
  echo "'${param[4]} yes' was added to ${file}"
  echo "${param[5]} $portssh" >> ${file}
  echo "'${param[5]} $portssh' was added to ${file}"
}

reload_sshd(){
  sudo /etc/init.d/ssh restart
  echo "Run 'sudo /etc/init.d/ssh restart'...OK"
}

# main
while getopts .h. OPTION
do
  case $OPTION in
    h)
    usage
    exit;;
    ?)
    usage
    exit;;
  esac
done

if [ -z "${file}" ]
then

file="/etc/ssh/sshd_config"
fi
backup_sshd_config
edit_sshd_config
reload_sshd

# If the SSH configuration was grateful check your sshd_config and then reload the script if you want with a Putty Client, allowing X11 forwarding 

sudo apt install lxde -y
startlxde
