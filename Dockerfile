FROM        ubuntu:14.04.2
MAINTAINER  Nebiyu "nebiyu@cedexis.com"
ENV REFRESHED_AT 2014-10-18

# Update the package repository and install applications
RUN apt-get update -qq && \
  apt-get upgrade -yqq && \
  apt-get -yqq install varnish && \
  apt-get -yqq install nginx && \
  apt-get -yqq clean

# stop nginx
CMD ["service nginx stop"]

# Make our custom VCLs available on the container
ADD default.vcl /etc/varnish/default.vcl

ENV NGINX_PORT 8082
ENV VARNISH_BACKEND_IP 127.0.0.1
ENV VARNISH_PORT 80

# Set up nginx to run on desired port and lay down test files to be served by nginx and cached by varnish
ADD default /etc/nginx/sites-available/default
CMD ["mkdir /usr/share/nginx/html/files"]
CMD ["mkdir /usr/share/nginx/html/files/test"]
CMD ["mkdir /usr/share/nginx/html/files/test/dir"]
ADD varnish.html /usr/share/nginx/html/varnish.html
ADD gurumeditation.txt /usr/share/nginx/html/files/test/dir/gurumeditation.txt

# start varnish

# Expose port 80
EXPOSE 80

# Expose volumes to be able to use data containers
VOLUME ["/var/lib/varnish", "/etc/varnish"]

ADD start.sh /start.sh
CMD ["/start.sh"]
