#
# Cookbook Name:: myossec
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# Hackish way to install ossec rpm since we don't have yum repo yet
bash "install_ossec" do
  user "root"
  code <<-EOH
  yum install -y https://www.atomicorp.com/channels/atomic/centos/6/x86_64/RPMS/GeoIP-1.4.8-1.1.el6.art.x86_64.rpm https://www.atomicorp.com/channels/atomic/centos/6/x86_64/RPMS/ossec-hids-2.7-24.el6.art.x86_64.rpm https://www.atomicorp.com/channels/atomic/centos/6/x86_64/RPMS/ossec-hids-client-2.7-24.el6.art.x86_64.rpm https://www.atomicorp.com/channels/atomic/centos/6/x86_64/RPMS/inotify-tools-3.13-2.el6.art.x86_64.rpm
  echo "done installing"
  EOH
end

bash "generate_key" do
  user "root"
  code <<-EOH
  /var/ossec/bin/agent-auth -m #{node['ossec']['server_address']}
  EOH
  not_if { ::File.exist?('/var/ossec/etc/client.keys') }
end

template "/var/ossec/etc/ossec.conf" do
  source "ossec.conf.erb"
end
