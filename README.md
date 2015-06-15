## Overview 

This project demonstrates how to create a private NPM registry within 
a Virtual Machine, and how to use that private registry with the NPM client.

You'll need Vagrant and VirtualBox.

## Getting started

###

```
vagrant up

# To enter the VM via SSH
vagrant ssh
```

## Using CouchDB

* View http://192.168.50.4:5984/.
* View http://192.168.50.4:5984/_utils/ for admin interface.

### Admin credentials

* Username: admin
* Password: password

## Using the registry

Set the registry so the npm client will use the local registry:

```
npm config set always-auth true

npm config set \
  registry=http://admin:password@192.168.50.4:5984/registry/_design/app/_rewrite

```

So now your ~/.npmrc should look like:

```
always-auth=true
registry=http://admin:password@192.168.50.4:5984/registry/_design/app/_rewrite
```

You then need to login:

```
npm login
```

### Switching back to the public registry

```
npm config set registry https://registry.npmjs.org/
npm login
```

## Authentication

The current strategy is to provide the auth credentials as part of the registry URL
and let couchdb handle the auth. Couchdb user credentials are sent in plaint text which is not ideal! 

It would perhaps be better to lock down the `npm login` operation to prevent new users 
from being created and then manually create users on the registry server to allow read/write.

### TODO

Couchdb SSL
