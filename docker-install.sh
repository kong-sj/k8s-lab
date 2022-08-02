#!/bin/bash

echo "=============================="
echo "======= INSTALL DOCKER ======="
echo "=============================="

# Check Ubuntu Version
VERSION=$(cat /etc/issue*)


if [[ "$VERSION" == *"Ubuntu"* ]]; then
echo "============================"
echo "Server platform is "$VERSION
echo "============================"
else
echo "Only available Linux/Ubuntu"
exit 1
fi


if [[ "$VERSION" == *"Ubuntu 18."* ]]; then
        apt -y update
        apt -y install apt-transport-https ca-certificates curl software-properties-common

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

        apt -y update
        apt-cache policy docker-ce
        apt -y install docker-ce




        elif [[ "$VERSION" == *"ubuntu 20."* ]]; then
                sudo apt -y install \
                     ca-certificates \
                     curl \
                     gnupg \
                     lsb-release

                curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

                echo \
                     "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
                     $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                apt -y update
                apt -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin

fi

systemctl start docker
systemctl enable docker

# Run hello-world containr
docker run hello-world

# Check docker installation
if [ $? == 0 ]
        then
                echo "======================================"
                echo "====== DOCKER INSTALL SUCCESSED ======"
                echo "======================================"

        else
                echo "====================================="
                echo "======= DOCKER INSTALL FAILED ======="
                echo "====================================="
fi
