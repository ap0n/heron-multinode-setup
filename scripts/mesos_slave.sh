unset http_proxy
unset https_proxy
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)
echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" | sudo tee /etc/apt/sources.list.d/mesosphere.list
sudo apt-get -y update
sudo apt-get install mesos -y
echo "zk://masternode:2181/mesos" | sudo tee /etc/mesos/zk
service zookeeper stop
echo manual | sudo tee /etc/init/zookeeper.override
service mesos-master stop
echo manual | sudo tee /etc/init/mesos-master.override
echo 172.16.99.38 | sudo tee /etc/mesos-slave/ip #replace the ip address of you machine here
sudo cp /etc/mesos-slave/ip /etc/mesos-slave/hostname
service mesos-slave start
