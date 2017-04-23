Heron multi-node setup
===============

Install the dependencies on all the nodes by running the following commands on ubuntu:
<pre>
$ sudo apt-get update -y
$ sudo apt-get install software-properties-common
$ sudo apt-get upgrade -y
$ sudo apt-get install git build-essential automake cmake libtool zip libunwind-setjmp0-dev zlib1g-dev unzip pkg-config -y
$ sudo apt-get install -y tar wget git
$ sudo apt-get install -y autoconf libtool
$ sudo apt-get -y install build-essential python-dev libcurl4-nss-dev libsasl2-dev libsasl2-modules maven libapr1-dev libsvn-dev
$ sudo add-apt-repository ppa:webupd8team/java
$ sudo apt-get update -y
$ sudo apt-get install oracle-java8-installer -y
$ export JAVA_HOME=/usr/lib/jvm/java-8-oracle
#Update the /etc/hosts file for all the nodes and ensure password-less ssh between master and all the slave nodes.
#You can copy all of the above commands into a .sh file, and run it together
`

1. Install Apache Mesos, by running the mesos_master.sh script on the master and mesos_slave.sh script on the slaves. Make sure the ip addresses are updated in the script before you run them.

2. Make sure the zookeeper node is receiving the heartbeats from the slaves by checking the web ui - localhost:5050

3. Install aurora in the cluster, by running the aurora_master.sh and aurora_slave.sh scripts on the masters and slaves respectively. localhost:8081/scheduler - web ui

4. Install hadoop 2.6, on the cluster and update the environment variables accordingly. Use hadoop_current.zip file and run the following commands:
<pre>
Master only:
$ sudo rm -rf /usr/local/hadoop_tmp/
$ sudo mkdir -p /usr/local/hadoop_tmp/
$ sudo mkdir -p /usr/local/hadoop_tmp/hdfs/namenode
$ hdfs namenode -format

Slaves only:
$ sudo rm -rf /usr/local/hadoop_tmp/hdfs/
$ sudo mkdir -p /usr/local/hadoop_tmp/
$ sudo mkdir -p /usr/local/hadoop_tmp/hdfs/datanode
</pre>
5. Run the dfs script, start-dfs.sh and make sure Datanodes are running in the slave nodes. Run the following commands:
<pre>
$ hdfs dfs -mkdir /user
$ hdfs dfs -mkdir /user/root
</pre>
6. Install Apache heron in user mode on ther master node as indicated in the website - [heron setup](http://twitter.github.io/heron/docs/getting-started/)

7. Copy all the conf files from aurora directory and replace the respective scripts in the ~/.heron/conf/aurora directory.

8. Create a zookeeper node, /heron/topologies using `$ /usr/share/zookeeper/bin/zkCli.sh -server masternode ` and type in:
<pre>
$ create /heron heron
$ create /heron/topologies heron-tracker
</pre>
9. Restart all the services - mesos, marathon, zookeeper, aurora-scheduler 

10. Create `/heron/topologies` directory in HDFS.

11. Copy the `.heron` directory into `/tmp/.heron` in the HDFS : `$ hadoop fs -copyFromLocal ~/.heron /tmp/`

12. If the directories constructed in the HDFS are different, update the `heron.aurora` file in `~/.heron/conf/aurora` and then update in HDFS too.

13. Go to `/etc/aurora/clusters.json` and name the cluster as `'aurora'`, otherwise you will get an error - "aurora: cluster not found" when submitting a topology.

14. Submit an example topology in Heron using the following command :
`$ heron submit aurora/root/devel --config-path ~/.heron/conf/ ~/.heron/examples/heron-examples.jar com.twitter.heron.examples.ExclamationTopology ExclamationTopology --verbose`
#Instead of 'devel', 'test' or 'prod' also can be used. 

15. Run heron-tracker and heron-ui on the master, and observe the topology statistics in localhost:8889

16. For troubleshooting, visit localhost:8081/scheduler and observe the stderr logs in case the tasks throttle. There might be errors like insufficient disks; In that case you should update the resource requirements in heron.aurora . eg: for 500MB, enter it as 500*MB .
