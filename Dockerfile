FROM ubuntu:18.04

WORKDIR /opt/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y curl software-properties-common systemd supervisor && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

RUN mkdir -p /var/log/supervisor

RUN mkdir -p /var/log/genieacs

RUN npm install libxmljs

RUN apt install -y ruby rails libsqlite3-dev default-libmysqlclient-dev build-essential liblzma-dev patch ruby-dev zlib1g-dev git

RUN npm install -y genieacs

RUN git clone https://github.com/zaidka/genieacs-gui.git

WORKDIR /opt/genieacs-gui/config

RUN cp graphs-sample.json.erb graphs.json.erb && \
    cp index_parameters-sample.yml index_parameters.yml && \
    cp summary_parameters-sample.yml summary_parameters.yml && \
    cp parameters_edit-sample.yml parameters_edit.yml && \
    cp parameter_renderers-sample.yml parameter_renderers.yml && \
    cp roles-sample.yml roles.yml && \
    cp users-sample.yml users.yml 

WORKDIR /opt/genieacs-gui/db/migrate/

RUN sed -i 's/Migration\[5.2\]/Migration\[5.1\]/g' *.rb 

RUN sed -i 's/Migration/Migration\[5.1\]/g' *.rb

WORKDIR /opt/genieacs-gui

RUN gem install bundler
RUN gem update --system
RUN gem install bundler
RUN gem install sqlite3 -v '1.3.13' --source 'https://rubygems.org/'
RUN gem install nokogiri -v '1.10.7' --source 'https://rubygems.org/'

RUN bundle install
RUN bundle

RUN rake db:create
RUN rake db:migrate
RUN sed -i 's/127.0.0.1/mongodb/g' /opt/node_modules/genieacs/config/config.json

WORKDIR /opt/

RUN git clone https://github.com/romanromanovv/genieacs
RUN cp genieacs/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN cp genieacs/startscript.sh /opt/startscript.sh
RUN chmod +x /opt/startscript.sh

CMD ["/usr/bin/supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
