FROM php:7.3-apache
ENV DEBIAN_FRONTEND=noninteractive
ENV ACCEPT_EULA=Y

#install sqlsrv extension
RUN apt-get update && apt-get install -y gnupg2
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - 
RUN curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list 
RUN apt-get update 
RUN ACCEPT_EULA=Y apt-get -y --no-install-recommends install msodbcsql17 unixodbc-dev 
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN docker-php-ext-enable sqlsrv pdo_sqlsrv

#install nano
RUN apt-get update && apt-get install -y nano

# Apache Config
# Allow .htaccess with RewriteEngine.
RUN a2enmod rewrite

# Authorise .htaccess files.
RUN sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

#copy project app to docker image
COPY . /var/www/html

#remove index.html file
RUN rm -rf /var/www/html/index.html 

# Ports
EXPOSE 80 5000
