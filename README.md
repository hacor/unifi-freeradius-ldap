#Use Unifi - FreeRadius - Google Secure LDAP 

With all respects to major designer jongoldsz

```
In the future this container image will be rebuild so you can pass a volume containing the certs and ENV values for the domain. Work in progress
```

This is a quick step-by-step guide to getting a Freeradius server set up to support G-Suite authentication for UniFi WPA2 enterprise wireless networks.

Note: At time of writing this guide, you will need G Suite Enterprise, G Suite Enterprise for Education, G Suite Education, or Cloud Identity Premium licensing to use Google's Secure LDAP service. If you don't have this licensing, you will not be able to get authentication working by following this guide.

## Configure your Google secure LDAP environment
### Follow steps 1-3 in Google's guide. https://support.google.com/a/answer/9048434?hl=en&ref_topic=9173976
- When you download the certificates archieve, extract the files and put both the certificate and key files into the certs folder.
- Be sure to click on the "Generate access credentials" link in step 3, to generate values for identity and password required for the next step.

## Make the necessary adaptations to the config files
### Modify ldap file to have the required settings to communicate with your Google Secure LDAP instance.
- Set values for `identity` and `password`. These values are given by Google in the previous step.
- Set value for `base_dn`. The value for `base_dn` is based on your G Suite domain, for example if your domain is example.org, the base_dn value would be `'dc=example,dc=org'`. If your domain is ui.com then the base_dn would be  `'dc=ui,dc=com'`.

### Modify  clients.conf file to have entries for all of your clients.
- Set `YOUR_CLIENT_NAME` to something that will help you figure out what client you are refering to.
- Set ipaddr to the IP address or subnet of your client(s), this value can be a WAN IP if your clients are behind a NAT or the LAN IP or subnet if your freeradius server is hosted locally (either on the same subnet or routable).
- Set secret to the secret your client(s) will use when communicating with the freeradius server. (This will be the secret value for the radius profile in the controller. As the controller can only store a single secret per site, if you have mulitple APs at a site connecting to the same freeradius server, make sure the secret is the same for all clients)

### Change the domain name to the correct one at the end of proxy.conf. This change makes it possible to login using your complete e-mail adress as well

Note: The default, inner-tunnel, and eap files have already been modified to support authenticating WPA2 eap requests against Google's Secure LDAP. These files are injected into the docker container when running Docker build .


## Build the container

`docker build -t whatever-name-you-want .`

This command will build the container with the config files and certs required to get freeradius working with Google's Secure LDAP. Remember that this docker container is explicitly for you because it contains certificates and passwords.

Run the following command to spin up the freeradius-gsuite container:

`docker run --network host --name freeradius -d whatever-name-you-want:latest`

If you encounter problems, it might be interesting to follow the output of the container by adding `-X` at the end of the previous command

`docker run --network host --name freeradius -d whatever-name-you-want:latest -X`

If you want the docker container to run in the background at the well know `-d` argument

`docker run -d --network host --name freeradius -d whatever-name-you-want:latest`

Note: The configuration files should be useable in freeradius servers in other environments, but the paths in the ldap file for the certificates, and the paths in the eap file for private_key_file, certificate_file, and ca_file will need to be adjusted to match the environment freeradius is installed in.
