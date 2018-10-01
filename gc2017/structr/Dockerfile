FROM structr/structr:2.1.4-SNAPSHOT
COPY ./structr.conf /var/lib/structr/structr.conf
COPY ./license.key /var/lib/structr/license.key
COPY ./wait-for /var/lib/structr/bin/wait-for
CMD /var/lib/structr/bin/wait-for neo4j-gc2017:7474 -t 300 -- /var/lib/structr/bin/start && tail -f /var/lib/structr/logs/server.log