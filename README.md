# Unifi - FreeRadius - Google Secure LDAP 

With all respects to major designer jongoldsz

This is a quick step-by-step guide to getting a Freeradius server set up to support G-Suite authentication for UniFi WPA2 enterprise wireless networks. This setup is tested with Unifi and Aerohive successfully. Also tests with OpenLDAP seemed to work.

Note: At time of writing this guide, you will need G Suite Enterprise, G Suite Enterprise for Education, G Suite Education, or Cloud Identity Premium licensing to use Google's Secure LDAP service. If you don't have this licensing, you will not be able to get authentication working by following this guide.

```
IMPORTANT
If you are using this image with Unifi Hardware, make sure the firmware version is 4.0.21 and not higher or the image won't work
```

## Configure your Google secure LDAP environment
Follow steps 1-3 in Google's guide. https://support.google.com/a/answer/9048434?hl=en&ref_topic=9173976
When you download the certificates archive, extract the files and remember this location, we need to give the certificates to the docker container.
Be sure to click on the "Generate access credentials" link in step 3, to generate values for identity and password required for the next step. This password is only shown once, so be careful not to close the window yet!

## Configuration
In order to successfully run the container, following environment variables are passed on to the container. If not all parameters are provided, the container will fail. Rename the `env/freeradius.env.sample` file to `env/freeradius.env` and make the necessary changes.

- `ACCESS_ALLOWED_CIDR` : The CIDR (e.g. 192.168.1.1/24) which is allowed access to the freeradius server. This will probably be the IP range of your Wifi Access Points.
- `BASE_DOMAIN`: The first part of your domain name used in the Google suite: `example` if your domain name is `example.com`
- `DOMAIN_EXTENSTION`: The last part of your domain name used in the Google suite: `com` if your domain name is `example.com`
- `GOOGLE_LDAP_USERNAME`: The username Google gave you when configuring the Client credentials
- `GOOGLE_LDAP_PASSWORD`: The password Google gave you when configuring the Client credentials 
- `SHARED_SECRET`: The shared secret needed to be able to talk to the FreeRADIUS server

In order to run the container also needs the directory where the certificates you received (and extracted) from Google are located. These files need to be mounted to the `/certs` folder and renamed to `ldap-client.crt` and `ldap-client.key` respectively.
Run the following command to spin up the freeradius-gsuite container:

`docker-compose up`

If you encounter problems, it might be interesting to follow the output of the container by uncommenting the `command: -X` line in `docker-compose.yaml`


Now the freeradius should be up and running and accepting connections using the `user@example.com` and `user` as login names.


## Adding a custom certificate for the EAP authentication

In order to change the `Example Server certificate` which you need to accept before logging in to the Freeradius server, you need to create your own Certificate Authority and server certificate. More info can be found in the container in the `/etc/raddb/certs/README` file.

You can use the container to create your new certificates as documented in the README file. When done you should need at least following files copied to the `./certs` directory here. Do not change their names!

- `ca.key`
- `ca.pem`
- `dh`
- `server.crt`
- `server.csr`
- `server.key`
- `server.p12`
- `server.pem`

Now you can restart the container and the new certificates will be used

Have fun!
Hacor
