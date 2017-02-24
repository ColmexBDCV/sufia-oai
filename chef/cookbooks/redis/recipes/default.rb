#
# Cookbook Name:: redis
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
log "Setup redis"

remote_file "/usr/local/src/epel-release-7-9.noarch.rpm" do
    source "http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm"
    action :create
end

remote_file "/usr/local/src/remi-release-7.rpm" do
    source "http://rpms.famillecollet.com/enterprise/remi-release-7.rpm"
    action :create
end

rpm_package "Install Epel Repo" do
    source "/usr/local/src/epel-release-7-9.noarch.rpm"
    action :install
end

rpm_package "Install Remi Repo" do
    source "/usr/local/src/remi-release-7.rpm"
    action :install
end

%w{ redis }.each do |pkg|
  package pkg do
    action :install
    options '--enablerepo=remi,remi-test'
  end
end

# #Configure
# bash "Configure Kernel" do
# 	code <<-EOH
# 		sysctl vm.overcommit_memory=1
# 		sysctl -w fs.file-max=100000
# 	EOH
# end

#Add Service to startup
bash "Add Service" do
	code <<-EOH
		chkconfig --add redis
		chkconfig --level 345 redis on
	EOH
end

#Start Service
log "Start redis-server"
%w{ redis }.each do |daemon|
    service daemon do
        action [:enable, :start]
    end
end
