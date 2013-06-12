BtCP by Sergey Sergeev <zhirafovod@gmail.com>

Copyright Sergey Sergeev

DESCRIPTION
-----------

Bittorrent copy (BtCP) [Cassandra](http://cassandra.apache.org/) node is used to publish Bittorent 'torrent' files and for signalling between nodes. The framework can work with a single node, recommended to have a Cassandra node per data center.

QUICK START
-----------

Quick start
 * [install Apache Cassandra node](http://wiki.apache.org/cassandra/GettingStarted)
 * download cassandra configuration file [cassandra.yaml.erb](), copy it to /etc/cassandra/cassandra.yaml, restart cassandra
 * download script [create.data]() and create cassandra keyspace and column families with the following command
    cassandra-cli -h localhost -f /var/tmp/create.data
 * make 'btcpcassa1' dns name be resolved to newly installed cassandra node on all BtCP daemon nodes or write Cassandra's node ip address to '../btcp-daemon/files/cookbooks/btcp/templates/default/btcp.conf.erb', as 'cassa_nodes' parameter, example:
    cassa_nodes = 192.168.1.1:9160

DEPLOYMENT
-----------

Deployment of a distributed framework heavily depends on deployment/configuration infrastructure. OpsCode Chef cookbooks are supplied and can be used either with chef-solo or with chef-client. Additionally debian package can be built. 

### Chef-solo

 * install chef and git packages (example for debian/ubuntu):
    DEBIAN_FRONTEND=noninteractive apt-get -y install chef git
 * clone BtCP 
    git clone https://github.com/zhirafovod/btcp.git && cd btcp/btcp-cassandra/

### Debian package

Debian package is useful in conjunction with a debian repostiory, to process debian package dependencies properly.

 * clone BtCP:
    git clone https://github.com/zhirafovod/btcp.git && cd btcp/btcp-cassandra/
 * build debian package:
    dpkg-buildpackage -rfakeroot -uc -us 
 * Upload 'deb' file to your repository

### Chef-client

 * Use cookbook [cassasndra](http://community.opscode.com/cookbooks/cassandra/) to deploy Cassandra cluster. 
 * Create keyspace and columnfamilies using cookbook [btcp-cassandra](https://github.com/zhirafovod/btcp/tree/master/btcp-cassandra/files/cookbooks/btcp-cassandra) 

LICENSE
-----------
Python BtCP is released under the [MIT License](http://www.opensource.org/licenses/MIT).
