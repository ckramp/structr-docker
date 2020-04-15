FROM structr/structr:2.3-SNAPSHOT
COPY ./structr.conf /var/lib/structr/structr.conf
COPY ./license.key /var/lib/structr/license.key
COPY ./wait-for /var/lib/structr/bin/wait-for
CMD /var/lib/structr/bin/wait-for neo4j-cc-node1:7474 -t 300 -- /var/lib/structr/bin/wait-for neo4j-cc-node2:7474 -t 300 -- /var/lib/structr/bin/wait-for neo4j-cc-node3:7474 -t 300 -- /var/lib/structr/bin/docker.sh