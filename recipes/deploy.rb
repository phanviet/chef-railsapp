include_recipe 'rvm'
include_recipe 'application-monit::service'
include_recipe 'application-nginx::service'
include_recipe 'application-unicorn::service'
include_recipe 'application-sidekiq::service'
include_recipe 'application-solr::service'

deploy_revision node[:app][:deploy_to] do
  repo 'https://github.com/phanviet/rails-app'
  checkout_branch 'master'
  user node[:app][:user]
  group node[:app][:group]
  rollback_on_error true
  environment(
    'RAILS_ENV' => node[:app][:rails_env]
  )

  create_dirs_before_symlink %w{vendor vendor/assets config}
  purge_before_symlink %w{vendor/bundle vendor/assets/bower_components log}

  symlinks(
    'bundle' => 'vendor/bundle',
    'bower' => 'vendor/assets/bower_components',
    'config/database.yml' => 'config/database.yml',
    'config/sunspot.yml' => 'config/sunspot.yml',
    'log' => 'log',
    'config/.env' => '.env'
  )

  migrate false

  before_restart do

    workspace_path = release_path

    ruby_exec 'Bundle install' do
      dir workspace_path
      code %(
        bundle install --path #{node[:app][:deploy_to]}/#{node[:app][:shared_path]}/bundle
      )
    end

    ruby_exec 'Migrate db' do
      dir workspace_path
      code %(
        bundle exec rake db:create RAILS_ENV=#{node[:app][:rails_env]}
        bundle exec rake db:migrate RAILS_ENV=#{node[:app][:rails_env]}
      )
    end

    ruby_exec 'Sunspot reindex' do
      dir workspace_path
      code %(
        bundle exec rake sunspot:reindex RAILS_ENV=#{node[:app][:rails_env]}
      )
    end

    ruby_exec 'Bower install and Assets precompile' do
      dir workspace_path
      code %(
        bundle exec rake bower:install:deployment RAILS_ENV=#{node[:app][:rails_env]}
        bundle exec rake assets:precompile RAILS_ENV=#{node[:app][:rails_env]}
      )
    end

  end

  notifies :restart, 'service[monit]'
  notifies :restart, 'service[nginx]'
  notifies :restart, 'service[unicorn]'
  notifies :restart, 'service[sidekiq]'
  notifies :restart, 'service[solr]'
end
