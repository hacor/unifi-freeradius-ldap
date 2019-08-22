# Unifi - FreeRadius - Google Secure LDAP 

With all respects to major designer jongoldsz

This is a quick step-by-step guide to getting a Freeradius server set up to support G-Suite authentication for UniFi WPA2 enterprise wireless networks. This setup is tested with Unifi and Aerohive successfully.

Note: At time of writing this guide, you will need G Suite Enterprise, G Suite Enterprise for Education, G Suite Education, or Cloud Identity Premium licensing to use Google's Secure LDAP service. If you don't have this licensing, you will not be able to get authentication working by following this guide.

## Configure your Google secure LDAP environment
Follow steps 1-3 in Google's guide. https://support.google.com/a/answer/9048434?hl=en&ref_topic=9173976
When you download the certificates archive, extract the files and remember this location, we need to give the certificates to the docker container.
Be sure to click on the "Generate access credentials" link in step 3, to generate values for identity and password required for the next step. This password is only shown once, so be careful not to close the window yet!

## Configuration
In order to successfully run the container, following environment variables should be passed on to the container. If not all parameters are provided, the container will fail.

- `ACCESS_ALLOWED_CIDR` : The CIDR (e.g. 192.168.1.1/24) which is allowed access to the freeradius server. This will probably be the IP range of your Wifi Access Points.
- `BASE_DOMAIN`: The first part of your domain name used in the Google suite: `example` if your domain name is `example.com`
- `DOMAIN_EXTENSTION`: The last part of your domain name used in the Google suite: `com` if your domain name is `example.com`
- `GOOGLE_LDAP_USERNAME`: The username Google gave you when configuring the Client credentials
- `GOOGLE_LDAP_PASSWORD`: The password Google gave you when configuring the Client credentials 

In order to run the container also needs the directory where the certificates you received (and extracted) from Google are located. These files need to be mounted to the `/certs` folder
Run the following command to spin up the freeradius-gsuite container:

`docker run -d --network host --name freeradius-secure-ldap -e ACCESS_ALLOWED_CIDR=192.168.1.1/24 -e BASE_DOMAIN=example -e DOMAIN_EXTENSION=com -e GOOGLE_LDAP_USERNAME=WhateverGoogleGaveYou -e GOOGLE_LDAP_PASSWORD=whateverGoogleGaveYou -v /Users/whatever/Downloads/Google_2022_05_13_50853:/certs haor/freeradius-google-ldap:latest`

If you encounter problems, it might be interesting to follow the output of the container by adding `-X` at the end of the previous command

`docker run -d --network host --name freeradius-secure-ldap -e ACCESS_ALLOWED_CIDR=192.168.1.1/24 -e BASE_DOMAIN=example -e DOMAIN_EXTENSION=com -e GOOGLE_LDAP_USERNAME=WhateverGoogleGaveYou -e GOOGLE_LDAP_PASSWORD=whateverGoogleGaveYou -v /Users/whatever/Downloads/Google_2022_05_13_50853:/certs haor/freeradius-google-ldap:latest -X`

Now the freeradius should be up and running and accepting connections using the `user@example.com` and `user` as login names.

## docker-compose

After copying the certificates to `./certs`.

```
cd env
cp freeradius.env.sample freeradius.env
```
Change the variable values for your environment and run the following command:
```
docker-compose up
```


Have fun!
Hacor
