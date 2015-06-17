#!/usr/bin/env bash
# ubuntu/trusty64

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

cd /vagrant/npm-registry-couchapp

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
