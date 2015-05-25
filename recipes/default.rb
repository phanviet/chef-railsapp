#
# Cookbook Name:: railsapp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe 'railsapp::ruby_version_gemset'

%w{config log pids sockets bundle bower cached-copy}.each do |dir|
  directory "#{node[:app][:deploy_to]}/#{node[:app][:shared_path]}/#{dir}" do
    owner node[:app][:user]
    group node[:app][:group]
    mode '0755'
    recursive true
    action :create
  end
end

# .env
upload_template "#{node[:app][:config_path]}/.env" do
  source 'env.erb'
end

# database

upload_template "#{node[:app][:config_path]}/database.yml" do
  source 'database.yml.erb'
end

include_recipe 'application-monit'
include_recipe 'application-nginx'
include_recipe 'application-unicorn'
include_recipe 'application-sidekiq'
include_recipe 'application-solr'
