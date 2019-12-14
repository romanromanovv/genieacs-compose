#!/bin/bash

npm install libxmljs
npm install -y genieacs
git clone https://github.com/zaidka/genieacs-gui.git
sleep 10
echo "DONE"
cd genieacs-gui
cp config/graphs-sample.json.erb config/graphs.json.erb
cp config/index_parameters-sample.yml config/index_parameters.yml
cp config/summary_parameters-sample.yml config/summary_parameters.yml
cp config/parameters_edit-sample.yml config/parameters_edit.yml
cp config/parameter_renderers-sample.yml config/parameter_renderers.yml
cp config/roles-sample.yml config/roles.yml
cp config/users-sample.yml config/users.yml
sed -i 's/Migration\[5.2\]/Migration\[5.1\]/g' /opt/genieacs-gui/db/migrate/*.rb
sed -i 's/Migration/Migration\[5.1\]/g' /opt/genieacs-gui/db/migrate/*.rb
gem install bundler
gem update --system
gem install bundler
gem install sqlite3 -v '1.3.13' --source 'https://rubygems.org/'
gem install nokogiri -v '1.10.7' --source 'https://rubygems.org/'
bundle install
bundle
rake db:create
rake db:migrate
sed -i 's/127.0.0.1/mongodb/g' /opt/node_modules/genieacs/config/config.json

cd /opt/node_modules/genieacs
bin/genieacs-cwmp &
bin/genieacs-nbi &
bin/genieacs-fs &

cd /opt/genieacs-gui
rails s
