FROM freeradius/freeradius-server:3.0.23

COPY configs/clients.conf /etc/freeradius/clients.conf
COPY configs/default /etc/freeradius/sites-available/default
COPY configs/inner-tunnel /etc/freeradius/sites-available/inner-tunnel
COPY configs/ldap /etc/freeradius/mods-available/ldap
COPY configs/eap /etc/freeradius/mods-enabled/eap
COPY configs/proxy.conf /etc/freeradius/proxy.conf
COPY init.sh /usr/local/bin
RUN chmod +x /usr/local/bin/init.sh
RUN ln -s /etc/freeradius/mods-available/ldap /etc/freeradius/mods-enabled/ldap

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["freeradius"]
