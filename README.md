BtCP by Sergey Sergeev <zhirafovod@gmail.com>

Copyright Sergey Sergeev

DESCRIPTION
-----------

Bittorrent copy (BtCP) is a framework written in Python using Bittorrent to coniniously distribute files from multiple data senders to a mutiple data receivers across multiple datacenters with unreliavle network connections. The framework uses [Cassandra](http://cassandra.apache.org/) to store and publish Bittorent files and for signalling between nodes, Transmissionbt as a bittorrent client, [Twistd](http://twistedmatrix.com/trac/) to run Bittorrent tracker (based on code from [python-bittorrent](https://github.com/JosephSalisbury/python-bittorrent)) and BtCP monitoring services. 

Alfa-stage software, most probably you will need to customize it heavily for your needs

WHY BtCP?
-----------

BtCP was designed to provide a way to continiously copy files (a kind of data pipeline) with the following requirements:
 * automatically re-flow data via a faster data center (If we need to copy files from datacenter A to B and C, and connection between A and B is slow - the data to A will be copied mostly via C)
 * copy data no more than once across a datanceter 
 * bandwidth throttling

If your goal is to distribute a file in a datacenter using Bittorent - please check [Murder](https://github.com/lg/murder), which is awesome for unfrequent file deployments

REQUIREMENTS
-----------

Tested under Debian Wheezy (7.0), can be deployed using chef or chef-solo or from Debian package.

DESIGN
-----------

BtCP framework consists of Cassandra nodes and BtCP daemon nodes. Any BtCP daemon node can be used to copy files or monitor queues. Recommended to deploy at least 1 cassandra node in a datacenter. 

LICENSE
-----------
Python BtCP is released under the [MIT License](http://www.opensource.org/licenses/MIT).