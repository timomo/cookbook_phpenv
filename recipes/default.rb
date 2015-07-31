#
# Cookbook Name:: phpenv
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
group "phpenv" do
  action :create
end

git "/opt/phpenv" do
  repository "https://github.com/sstephenson/phpenv.git"
  revision "master"
  user "root"
  group "phpenv"
  action :sync
end

directory "/opt/phpenv/plugins" do
  action :create
end

git "/opt/phpenv/plugins/ruby-build" do
  repository "https://github.com/sstephenson/ruby-build.git"
  revision "master"
  user "root"
  group "phpenv"
  action :sync
end

template "/etc/profile.d/phpenv.sh" do
  source "profile.d/phpenv.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

# install php 5.4.16
bash "install php" do
  code <<-_EOH_
    source /etc/profile.d/phpenv.sh
    phpenv install 5.4.16
    phpenv global 5.4.16
  _EOH_
  not_if { File.exist?("/opt/phpenv/shims/ruby") }
end