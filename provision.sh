#!/usr/bin/env bash
# ubuntu/trusty64

echo "Adding software repos..."
add-apt-repository -y ppa:nginx/stable
curl -sL https://deb.nodesource.com/setup_0.12 | bash -

echo "Installing software..."
apt-get install -y \
  git \
  build-essential \
  couchdb \
  nodejs \
  nginx

echo "Setting up couchapp..."
/vagrant/couchapp.sh

echo "Starting registry proxy.."
cd /vagrant/registry-proxy && npm start

echo "Setting up nginx..."
ln -s /vagrant/nginx/registry.mydomain.com.conf /etc/nginx/sites-enabled/registry.mydomain.com.conf
service nginx restart

echo "All done!"
