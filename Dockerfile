FROM ubuntu:bionic

WORKDIR /opt/

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \ 
    apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y curl software-properties-common && \
    curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

##RUN npm install libxmljs

RUN apt install -y ruby rails libsqlite3-dev default-libmysqlclient-dev build-essential liblzma-dev patch ruby-dev zlib1g-dev git

##RUN npm install -y genieacs

COPY startscript.sh startscript.sh

CMD ./startscript.sh
