unset http_proxy
unset https_proxy
wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-executor_0.12.0_amd64.deb
dpkg -i aurora-executor_0.12.0_amd64.deb
sudo sh -c 'echo "MESOS_ROOT=/tmp/mesos" >> /etc/default/thermos'
