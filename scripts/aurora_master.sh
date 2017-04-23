unset http_proxy
unset https_proxy
wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-scheduler_0.12.0_amd64.deb
dpkg -i aurora-scheduler_0.12.0_amd64.deb
sudo -u aurora mkdir -p /var/lib/aurora/scheduler/db
sudo -u aurora mesos-log initialize --path=/var/lib/aurora/scheduler/db
unset http_proxy
unset https_proxy
wget -c https://apache.bintray.com/aurora/ubuntu-trusty/aurora-tools_0.12.0_amd64.deb
sudo dpkg -i aurora-tools_0.12.0_amd64.deb
service aurora-scheduler restart
