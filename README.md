BtCP by Sergey Sergeev <zhirafovod@gmail.com>

Copyright Sergey Sergeev

DESCRIPTION
-----------

Bittorrent copy (BtCP) is a framework written in Python using Bittorrent to continiously distribute files from multiple data senders to a mutiple data receivers across multiple datacenters with unreliable network connections. The framework uses [Cassandra](http://cassandra.apache.org/) to publish Bittorent 'torrent' files and for signalling between nodes, [Transmissionbt](http://www.transmissionbt.com/) as a bittorrent client, [Twistd](http://twistedmatrix.com/trac/) to run Bittorrent tracker (based on code from [python-bittorrent](https://github.com/JosephSalisbury/python-bittorrent)) and BtCP monitoring services. 

Alfa-stage software, most probably you will need to customize it heavily for your needs

[Documentation](https://github.com/zhirafovod/btcp/wiki/BtCP-Docs)
[Roadmap](https://github.com/zhirafovod/btcp/wiki/Roadmap)

WHY BtCP?
-----------

BtCP was designed to provide a way to continuously copy files (a kind of data pipeline) with the following requirements:
 * automatically re-flow data via a faster data center (If we need to copy files from datacenter A to B and C, and connection between A and B is slow - the data to B will be copied mostly via C)
 * copy data no more than once across a datanceter 
 * bandwidth throttling

If your goal is to distribute a file in a datacenter via Bittorent - please check [Murder](https://github.com/lg/murder), which works great for that

REQUIREMENTS
-----------

Tested to work with Debian Wheezy (7.0), can be deployed using OpsCode Chef or from Debian package.

DEPLOYMENT
-----------

Recommended way to deploy BtCP cluster is to deploy each node inside a [Linux Containers (LXC)](http://lxc.sourceforge.net/). 

> Requirements: btcpcassa1 should resolve to btcp-cassandra instances ip addresses
> Requirements: full host name will be used as a node name, unless 'hostname' is specified in /etc/btcp/btcp.conf

### Quick start with OpsCode Chef-solo

####  Install one btcp-cassandra node

<pre>
apt-get -y install git && 
git clone -b v0.2 https://github.com/zhirafovod/btcp.git && 
cd btcp && 
bash install.sh btcp-cassandra
</pre>

#### Install btcp-daemon nodes

 * make sure btcpcassa1 name resolves to IP adress of btcp-cassandra node on each btcp-daemon node. The easiest way is to write it to /etc/hosts file:
<pre>
192.168.100.10 btcpcassa1
</pre>

 * install btcp-daemon node
<pre>
apt-get -y install git && 
git clone -b v0.2 https://github.com/zhirafovod/btcp.git && 
cd btcp && 
bash install.sh btcp-daemon
</pre>

### Recommended with OpsCode Chef-client

 * OpsCode chef recipes for [BtCP Cassandra node](https://github.com/zhirafovod/btcp/btcp-cassandra-cookbooks)
 * OpsCode chef recipes for [BtCP Daemon node](https://github.com/zhirafovod/btcp/btcp-daemon-cookbooks)

### Deprecated with Debian Package

 * Debian package source for [BtCP Cassandra node](https://github.com/zhirafovod/btcp/btcp-cassandra-daemon)
 * Debian package source for [BtCP Daemon node](https://github.com/zhirafovod/btcp/btcp-daemon-debian)

DESIGN
-----------

BtCP framework consists of Cassandra nodes and BtCP daemon nodes. Any BtCP daemon node can be used to copy files or monitor queues. Recommended to deploy at least 1 cassandra node in a datacenter. 

LICENSE
-----------
Python BtCP is released under the [MIT License](http://www.opensource.org/licenses/MIT).
