name             'railsapp'
maintainer       'YOUR_COMPANY_NAME'
maintainer_email 'vietphxfce@gmail'
license          'All rights reserved'
description      'Installs/Configures railsapp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'rvm'
depends 'application-defaults'
depends 'application-nginx'
depends 'application-unicorn'
depends 'application-sidekiq'
depends 'application-solr'
