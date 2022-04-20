#!/bin/bash
amazon(){
    echo "AWS instance detected."
    sleep 2
    sudo yum update -y
	sudo amazon-linux-extras install docker -y
    sudo yum install -y docker
    sudo service docker start
	sudo chkconfig docker on
    sudo usermod -a -G docker ec2-user
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
	sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
centos(){
    echo "CentOS detected."
    sleep 2
	sudo yum install -y http://mirror.centos.org/centos/7/extras/x86_64/Packages/container-selinux-2.107-3.el7.noarch.rpm
        sudo yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2
        sudo yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install -y docker-ce
    sudo systemctl start docker
	sudo systemctl enable docker
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
deb(){
    echo "Debian detected. (Warning: Older versions of Debian may require manual installation)"
    sleep 2
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo service docker start
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
ubuntu(){
    echo "Ubuntu detected."
    sleep 2
    sudo apt-get update -y
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt-get update -y
    sudo apt-get install -y docker-ce
    sudo service docker start
	sudo chkconfig docker on
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
fedora(){
    echo "Fedora detected."
    sleep 2
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager \
        --add-repo \
        https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce
    sudo systemctl start docker
	sudo systemctl enable docker
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
redhat8()
{
    echo "Redhat 8 detected."
	sudo curl  https://download.docker.com/linux/centos/docker-ce.repo -o /etc/yum.repos.d/docker-ce.repo
	sudo yum makecache
	sudo yum install -y yum-utils \
			yum-config-manager \
			device-mapper-persistent-data \
			lvm2
	sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
	sudo yum install -y docker-ce  --nobest
    sudo systemctl start docker
	sudo systemctl enable docker
    sudo curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo echo "Docker installation complete"
}
# if/else block used to determine which OS docker is being installed on
if hash docker; then 
    echo "Docker installation complete"
elif grep -q -i "release 8" /etc/redhat-release; then
	redhat8
elif cat /etc/lsb-release | grep "Ubuntu" > /dev/null; then
    ubuntu
elif uname -rv | grep "amzn" > /dev/null; then
    amazon
elif hash dnf; then
    fedora
elif hash yum; then
    centos
elif hash apt-get; then
    deb
else
    echo "Unsupported version of Linux. Please consult https://docs.docker.com/install/ for instructions."
fi

shopt -s nocasematch
sudo systemctl start docker
sudo systemctl enable docker

