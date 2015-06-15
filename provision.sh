#!/usr/bin/env bash
# ubuntu/trusty64

curl -sL https://deb.nodesource.com/setup_0.12 | bash -
apt-get install -y git build-essential
apt-get install -y couchdb
apt-get install -y nodejs
apt-get install -y nginx

echo "Setting up couchdb..."

sed -i -- \
  's/^\[couch_httpd_auth\]/\[couch_httpd_auth\]\npublic_fields = appdotnet, avatar, avatarMedium, avatarLarge, date, email, fields, freenode, fullname, github, homepage, name, roles, twitter, type, _id, _rev\nusers_db_public = false\nrequire_valid_user = true/' \
  /etc/couchdb/local.ini
sed -i -- \
  's/^\[httpd\]/\[httpd\]\nsecure_rewrites = false\nbind_address = 0.0.0.0/' \
  /etc/couchdb/local.ini
sed -i -- \
  's/^\[couchdb\]/\[couchdb\]\ndelayed_commits = false/' \
  /etc/couchdb/local.ini
sed -i -- \
  's/^\[admins\]/\[admins\]\nadmin = password/' \
  /etc/couchdb/local.ini
sed -i -- \
  's/^\[vhosts\]/\[vhosts\]\nregistry\.mydomain\.com = \/registry\/_design\/app\/_rewrite\//' \
  /etc/couchdb/local.ini

service couchdb restart

echo "Downloading couchapp files..."
git clone git://github.com/npm/npm-registry-couchapp /root/npm-registry-couchapp && cd $_

echo "Installing couchapp node modules..."
npm install

echo "Building couchapp..."
curl -X PUT http://admin:password@127.0.0.1:5984/registry

npm start \
  --npm-registry-couchapp:couch=http://admin:password@127.0.0.1:5984/registry

npm run load \
  --npm-registry-couchapp:couch=http://admin:password@127.0.0.1:5984/registry

NO_PROMPT=true npm run copy \
  --npm-registry-couchapp:couch=http://admin:password@127.0.0.1:5984/registry

echo "Replicating the npm public registry in the background..."
curl -X POST \
  http://admin:password@127.0.0.1:5984/_replicate \
  -d '{"source":"https://skimdb.npmjs.com/registry/", "target":"registry", "continuous":true, "create_target":true}' \
  -H "Content-Type: application/json"

echo "Setting up nginx..."
ln -s /vagrant/nginx/registry.mydomain.com.conf /etc/nginx/sites-enabled/registry.mydomain.com.conf
service nginx restart

echo "All done!"
