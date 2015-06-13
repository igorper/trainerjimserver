__Creating a certificate__:

See [these instructions](http://www.akadia.com/services/ssh_test_certificate.html).

```
openssl genrsa -out server.key 2048

OPENSSL_CONF=/c/Program\ Files\ \(x86\)/Git/ssl/openssl.cnf openssl req -new -key server.key -out server.csr
```

__Starting an HTTPS server instance__:

```
thin start -p 3001 --ssl --ssl-key-file certificates/server.key --ssl-cert-file certificates/server.crt
```