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

# create temp git repo
git "/tmp/phpenv-install" do
  repository "https://github.com/CHH/phpenv.git"
  revision "master"
  user "root"
  group "phpenv"
  action :sync
end

bash "run phpenv-install" do
  code <<-_EOH_
    export PHPENV_ROOT=/opt/phpenv
    cd /tmp/phpenv-install/bin
    ./phpenv-install.sh
  _EOH_
  not_if { File.exist?("/opt/phpenv/bin/phpenv") }
end

template "/etc/profile.d/phpenv.sh" do
  source "profile.d/phpenv.sh.erb"
  owner "root"
  group "root"
  mode "0644"
end

directory "/tmp/phpenv-install" do
  action :delete
end

git "/opt/phpenv/plugins/php-build" do
  repository "https://github.com/php-build/php-build.git"
  revision "master"
  user "root"
  group "phpenv"
  action :sync
end
