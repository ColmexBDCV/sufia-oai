#
# Cookbook Name:: flush_iptables
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "Flush IP Tables" do
  user "root"
  code <<-EOH
    iptables -F
    service iptables save
  EOH
end

