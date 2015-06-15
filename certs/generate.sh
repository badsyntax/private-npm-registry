#!/usr/bin/env bash

openssl genrsa -des3 -out cert.key.pass 2048
openssl rsa -in cert.key.pass -out cert.key
openssl req -new -key cert.key -out cert.csr
openssl x509 -req -days 3650 -in cert.csr -signkey cert.key -out cert.pem

