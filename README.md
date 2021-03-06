## Overview 

This is a WIP project that demonstrates how to create a private npm registry within 
a Virtual Machine, and how to use that private registry with the npm client.

The private registry will replicate the public registry. You can pubish
and install private modules, and install public modules, but you cannot
publish any modules to the public registry.

It uses https://github.com/npm/npm-registry-couchapp for the couchdb registry.

## Getting started

You'll need the latest versions of Vagrant and VirtualBox installed.

```
git clone https://github.com/badsyntax/private-npm-registry private-npm-registry && cd $_
vagrant up
```

Edit your hosts file (`/etc/hosts`) and add:

```
192.168.50.4 registry.mydomain.com
```

## Using CouchDB

* View https://registry.mydomain.com/.
* View http://192.168.50.4/_utils/ for admin interface.

### Admin credentials

* Username: admin
* Password: password

## Using the registry

Set the registry, let npm accept self-signed certs, and login:

```
npm config set always-auth true
npm config set registry https://admin:password@registry.mydomain.com/
npm config set strict-ssl 0
npm login
```

### Switching back to the public registry

```
npm config set registry https://registry.npmjs.org/
npm config set strict-ssl 1
npm login
```

## Authentication

The current strategy is to provide the admin auth credentials as part of the registry URL
and let couchdb handle the auth. Couchdb admin credentials are stored in plaint text which is not ideal! 

It would perhaps be better to lock down the `npm login` operation to prevent new users 
from being created, and then manually create users on the registry server to allow read/write.

Even better, provide a custom authenticator for `npm login` to use 3rd party auth services.

### TODO

* Couchdb SSL
* Proxy public repos to the public registry instead of replication

