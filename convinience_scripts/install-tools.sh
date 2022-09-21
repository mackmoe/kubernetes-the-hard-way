#!/bin/bash


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Installing the Client Tools"

function golang_version_check() {
	which go && \
	if [[ $? -ne 0 ]]; then
		apt install golang-go -y
	fi
}

function install_client_tools() {
	pushd /tmp
	wget -q --show-progress --https-only --timestamping https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssl https://storage.googleapis.com/kubernetes-the-hard-way/cfssl/1.4.1/linux/cfssljson && \
	chmod +x cfssl cfssljson && \
	mv cfssl cfssljson /usr/local/bin/ && \
	echo -e "Verify cfssl and cfssljson version 1.4.1 or higher is installed... \ncfssl is $(cfssl version)\ncfssljson is $(cfssljson --version)" && \
	sleep 2
	echo -e "Installing kubectl binary..."; \
	wget https://storage.googleapis.com/kubernetes-release/release/v1.21.0/bin/linux/amd64/kubectl && \
	chmod +x kubectl /usr/local/bin/ && \
	echo -e "Verify kubectl version 1.21.0 or higher is installed.\n $(kubectl version --client)"
	popd
}


golang_version_check
install_client_tools
if  [[ $? == 0 ]]; then
    echo "Install succeeded"
else
    echo "Install failed"
    echo $1
fi
