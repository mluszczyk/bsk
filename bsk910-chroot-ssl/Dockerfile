FROM ubuntu
 
MAINTAINER Michał Łuszczyk

RUN apt-get update && apt-get install -y \
    apache2 \
    openssl
 
COPY index.html /var/www/html/index.html
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY newcert.pem /etc/ssl/certs/newcert.pem
COPY newkey.pem /etc/ssl/private/newkey.pem

RUN a2enmod ssl
RUN a2ensite default-ssl
 
EXPOSE 80 443
 
CMD ["apachectl", "-D", "FOREGROUND"]

