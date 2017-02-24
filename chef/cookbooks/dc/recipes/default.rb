#
# Cookbook Name:: LA
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
log "Setup DC"

log "Install Packages"

# install ruby
%w{ git ImageMagick unzip }.each do |pkg|
  package pkg do
    action :install
  end
end

remote_file "/usr/local/src/fits-0.8.5.zip" do
    source "http://projects.iq.harvard.edu/files/fits/files/fits-0.8.5.zip"
    action :create
end

bash "Get Fits" do
  cwd "/usr/local/src/"
	code <<-EOH
  unzip fits-0.8.5.zip
  cd fits-0.8.5
  chmod a+x /usr/local/src/fits-0.8.5/fits.sh
  fits.sh -h
  ln -s /usr/local/src/fits-0.8.5/fits.sh /bin/fits
	EOH
end

remote_file "/usr/local/src/LibreOffice_5.0.6_Linux_x86-64_rpm.tar.gz" do
    source "http://download.documentfoundation.org/libreoffice/stable/5.0.6/rpm/x86_64/LibreOffice_5.0.6_Linux_x86-64_rpm.tar.gz"
    action :create
end

bash "Get LibreOffice" do
  cwd "/usr/local/src/"
	code <<-EOH
  tar -xvf LibreOffice_5.0.6*
  cd LibreOffice_5.0.6*
  yum -y localinstall RPMS/*.rpm
	EOH
end

remote_file "/usr/local/src/hsj-8.1.1.tar.gz" do
    source "http://www.handle.net/hnr-source/hsj-8.1.1.tar.gz"
    action :create
end
