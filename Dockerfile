FROM navidonskis/nginx-php5.6

ENV DBDRIVE='mysql'
ENV DBHOST='127.0.0.1'
ENV DBPORT='3306'
ENV DBNAME='pdm_wp'
ENV DBUSER='wp'
ENV DBPASS='wp'
ENV DBPREFIX='wp_'
ENV URL='localhost'
ENV TITLE='title'
ENV ADMUSER='admin' 
ENV ADMPASS='pass1234' 
ENV ADMMAIL='a@a.com'

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y 
RUN DEBIAN_FRONTEND=noninteractive apt-get install curl php5-cli vim wget curl nodejs npm git unzip mysql-client -y -o Dpkg::Options::="--force-confold"

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
            chmod +x wp-cli.phar && \
            sudo mv wp-cli.phar /usr/local/bin/wp-cli


RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer --version=1.10.20

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | sh && . ~/.profile && nvm install node && nvm use node

RUN npm config set strict-ssl false && npm install -g bower

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN git clone https://github.com/mbnunes/monitor-de-metas.git

RUN wget http://br.wordpress.org/wordpress-3.9.1-pt_BR.zip && \
    unzip wordpress-3.9.1-pt_BR.zip && \
    cp -R wordpress/* monitor-de-metas && \
    rm -rf wordpress && rm -rf wordpress-3.9.1-pt_BR.zip

COPY ./entrypoint/entrypoint.sh .

EXPOSE 80

ENTRYPOINT ["bash", "entrypoint.sh"]
