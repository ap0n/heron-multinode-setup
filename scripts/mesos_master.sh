unset http_proxy
unset https_proxy
# Mesosphere
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update
sudo apt-get install mesosphere -y
# Mesos and marathon configuration
echo "zk://masternode:2181/mesos" | sudo tee /etc/mesos/zk
echo "1" | sudo tee /etc/zookeeper/conf/myid
echo "1" | sudo tee /etc/mesos-master/quorum
echo 192.168.1.14 | sudo tee /etc/mesos-master/ip #replace IP address of your machine here
cp /etc/mesos-master/ip /etc/mesos-master/hostname
sudo mkdir -p /etc/marathon/conf
sudo cp /etc/mesos-master/hostname /etc/marathon/conf
sudo cp /etc/mesos/zk /etc/marathon/conf/master
sudo cp /etc/marathon/conf/master /etc/marathon/conf/zk
echo "zk://masternode:2181/marathon" | sudo tee /etc/marathon/conf/zk
service mesos-slave stop
echo manual | sudo tee /etc/init/mesos-slave.override
#Restart all services
service zookeeper restart
service mesos-master restart
service marathon restart
