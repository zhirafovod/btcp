#node.keys().each do |k|
#  puts k
#end
#node['vagrant']['config']['keys']['vm'].keys().each do |k|
#  puts k
#end
#puts node['ipaddress']

# puts 
debian_version = File.open('/etc/debian_version'){ |file| file.read }
if debian_version.start_with? "wheezy"
        cookbook_file "/etc/apt/sources.list" do
                source "sources.list.wheezy.erb"
                mode "0644"
                owner "root"
                group "root"
                action :create
                notifies :run, "execute[aptitude update]", :immediately
        end
elsif debian_version.start_with? "6"
        #squeeze
        cookbook_file "/etc/apt/sources.list" do
                source "sources.list.wheezy.erb"
                mode "0644"
                owner "root"
                group "root"
                action :create
                notifies :run, "execute[aptitude update]", :immediately
        end
        execute "apt-get -y --force-yes dist-upgrade"
end

execute "aptitude update" do
  action :nothing
end

execute "gpg --keyserver pgp.mit.edu --recv-keys F758CE318D77295D"
execute "gpg --export --armor F758CE318D77295D | apt-key add -"
execute "gpg --keyserver pgp.mit.edu --recv-keys 2B5C1B00"
execute "gpg --export --armor 2B5C1B00 | apt-key add -"
execute "gpg --fetch-key http://apt.opscode.com/packages@opscode.com.gpg.key"
execute "gpg --export packages@opscode.com | tee /etc/apt/trusted.gpg.d/opscode-keyring.gpg > /dev/null"

execute "aptitude update"

package 'cassandra'

user "vagrant" do
  comment "vagrant user for python-btcp-daemon"
  system true
  shell "/bin/false"
end

# install packages
package 'screen'
package 'vim'

# init data on the master
execute "cassandra-cli -h localhost -f /var/tmp/create.data"

# install cassandra configuration
service "cassandra" do
  action :stop
end


cookbook_file "/etc/cassandra/cassandra.yaml" do
	source "cassandra.yaml.erb"
	mode "0644"
  owner "root"
  group "root"
  action :create
end

#service "transmission-daemon" do
#  action :start
#end
