rails application deploy example Cookbook
============

- This cookbook helps you deploy the rails application quickly with below cookbooks:
  + [rvm](https://github.com/fnichol/chef-rvm)
  + monit
  + nginx
  + solr
  + postgresql
  + nodejs
  + [redisio](https://github.com/brianbianco/redisio)
  + [application-defaults](https://github.com/phanviet/chef-application-defaults.git)
  + [application-nginx](https://github.com/phanviet/chef-application-nginx.git)
  + [application-monit](https://github.com/phanviet/chef-application-monit.git)
  + [application-unicorn](https://github.com/phanviet/chef-application-unicorn.git)
  + [application-sidekiq](https://github.com/phanviet/chef-application-sidekiq.git)
  + [application-solr](https://github.com/phanviet/chef-application-solr.git)

Templates
----------
  + Updating application config in `env.erb`

Usage
-----
### Recipe

- `recipe[railsapp]`: Setup rails application such as: templates, configs, logs, db, ...
- `recipe[railsapp::ruby_version_gemset]`: Create ruby version and gemset for rails application
- `recipe[railsapp::vagrant]`: Fixed `rvm` installed on vagrant
- `recipe[railsapp::deploy]`: Deploy rails application

You should run `recipe[railsapp]` once for provision. After that, using below command to deploy rails application

```bash
bundle exec knife solo cook <user>@<host> -o "recipe[railsapp::deploy]"
```

### Environment config example

```json
{
  "name": "staging",
  "description": "The master development branch",
  "json_class": "Chef::Environment",
  "chef_type": "environment",
  "default_attributes": {
  },
  "override_attributes": {
    "postgresql": {
      "password": {
        "postgres": "postgresql@123"
      }
    },
    "monit": {
      "port": 2812,
      "address": "localhost",
      "allow": [
        "localhost"
      ],
      "poll_start_delay": false
    },
    "app": {
      "domain": "192.168.33.13",
      "user": "vagrant",
      "group": "vagrant",
      "ruby_ver": "ruby-2.1.5",
      "name": "railsapp",
      "ruby_gemset": "railsapp",
      "rails_env": "production"
    }
  }
}
```

### Run list example

```json
{
  "name": "railsapp",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "run_list": [
    "recipe[railsapp::ruby_version_gemset]"
  ],
  "env_run_lists": {
    "staging": [
      "recipe[railsapp]"
    ]
  }
}
```