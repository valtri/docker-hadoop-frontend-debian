FROM valtri/docker-puppet-deb7
MAINTAINER František Dvořák <valtri@civ.zcu.cz>

# ==== system ====

COPY ./krb5.conf /etc

# ==== puppet ====

RUN apt-get update && apt-get install -y ca-certificates
RUN puppet module install cesnet-site_hadoop

# ==== hadoop ====

# not needed, just perform some less fragile steps sooner
COPY ./java.pp /root
RUN puppet apply /root/java.pp --test; test $? -eq 2
RUN apt-get update && apt-get install -y acl procps heimdal-clients python-scipy
COPY ./cloudera.pp /root
RUN puppet apply /root/cloudera.pp --test; test $? -eq 2
RUN apt-get update && apt-get install -y hadoop-doc
RUN apt-get update && apt-get install -y zookeeper
RUN rm /root/cloudera.pp /root/java.pp

# the main deployment
COPY ./hadoop.pp /root
RUN puppet apply /root/hadoop.pp --test; test $? -eq 2

# ==== cleanup ====

RUN apt-get clean \
&& rm -rf /var/lib/apt/lists/*
