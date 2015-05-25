# database
default[:app][:db][:host] = '<%= ENV["DB_HOST"] %>'
default[:app][:db][:database] = '<%= ENV["DB_DATABASE"] %>'
default[:app][:db][:username] = '<%= ENV["DB_USERNAME"] %>'
default[:app][:db][:password] = '<%= ENV["DB_PASSWORD"] %>'