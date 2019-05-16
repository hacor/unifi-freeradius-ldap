FROM freeradius/freeradius-server:3.0.19
COPY certs/*.key /etc/freeradius/certs/ldap-client.key
COPY certs/*.crt /etc/freeradius/certs/ldap-client.crt
RUN chown freerad:freerad /etc/freeradius/certs/ldap-client* && chmod 640 /etc/freeradius/certs/ldap-client*

COPY configs/clients.conf /etc/freeradius/clients.conf
COPY configs/default /etc/freeradius/sites-available/default
COPY configs/inner-tunnel /etc/freeradius/sites-available/inner-tunnel
COPY configs/ldap /etc/freeradius/mods-available/ldap
COPY configs/eap /etc/freeradius/mods-enabled/eap
COPY configs/proxy.conf /etc/freeradius/proxy.conf
RUN ln -s /etc/freeradius/mods-available/ldap /etc/freeradius/mods-enabled/ldap
