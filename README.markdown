# Info

Hadoop frontend using [cluster deployed at MetaCentrum](http://www.metacentrum.cz/en/hadoop).

Available clients:

* Hadoop
* Hbase
* Hive
* Pig
* Spark

# Launch

Update image:

    docker pull valtri/docker-hadoop-frontend-debian

Launch with login shell:

    docker run -it --name hadoop_frontend valtri/docker-hadoop-frontend-debian /bin/bash -l

# Tags

* **latest**, **8**: Debian 8/jessie
* **7**: Debian 7/wheezy
