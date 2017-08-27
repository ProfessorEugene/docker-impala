#ubuntu trusty build
#this is a fork off codingtony and updated to impala 2.0.1
#see: https://github.com/codingtony/docker-impala
#see: http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/cdh_ig_cdh5_install.html
#see: http://www.cloudera.com/content/cloudera/en/documentation/core/latest/topics/impala_noncm_installation.html
#To test: docker run --rm -ti rooneyp1976/impala /start-bash.sh

FROM ubuntu:14.04
MAINTAINER cpcloud@gmail.com

COPY files/home /home/

RUN apt-get update -y
RUN apt-get install apt-transport-https -y
RUN apt-get upgrade -y

RUN apt-get install wget -y
RUN wget http://archive.cloudera.com/cdh5/one-click-install/trusty/amd64/cdh5-repository_1.0_all.deb
RUN dpkg -i /cdh5-repository_1.0_all.deb
RUN sudo apt-get update -y

# install oracle java 8
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:webupd8team/java -y
RUN apt-get update -y
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get update -y
RUN apt-get install -y oracle-java8-installer vim --fix-missing

RUN apt-get update -y
RUN apt-get upgrade -y

# install HDFS and impala
RUN apt-get install hadoop-hdfs-namenode hadoop-hdfs-datanode -y
RUN apt-get install impala impala-server impala-shell impala-catalog impala-state-store -y

# install postgres for the metastore
RUN apt-get install bash-completion postgresql postgresql-server-dev-9.3 -y

# install the postgres jdbc driver
RUN curl -o /usr/share/java/postgresql-jdbc4.jar https://jdbc.postgresql.org/download/postgresql-42.1.3.jar
RUN ln -s /usr/share/java/postgresql-jdbc4.jar /usr/lib/hive/lib/postgresql-jdbc4.jar

ADD files/hive-grant-perms.sql /usr/lib/hive/scripts/metastore/upgrade/postgres/

RUN sed -i 's#hive-txn-schema-0.13.0.postgres.sql#/usr/lib/hive/scripts/metastore/upgrade/postgres/hive-txn-schema-0.13.0.postgres.sql#g' /usr/lib/hive/scripts/metastore/upgrade/postgres/hive-schema-1.1.0.postgres.sql

# setup the metastore pg database
RUN sed -i "s:#listen_addresses = 'localhost':listen_addresses = '*':g" \
    /etc/postgresql/*/main/postgresql.conf
RUN sed -i s:peer:trust:g /etc/postgresql/*/main/pg_hba.conf
RUN sed -i s:md5:trust:g /etc/postgresql/*/main/pg_hba.conf
RUN sed -i s:127.0.0.1/32:0.0.0.0/0:g /etc/postgresql/*/main/pg_hba.conf
RUN service postgresql start \
    && sleep 10 \
    && sudo -u postgres psql -c " \
        CREATE ROLE hiveuser LOGIN PASSWORD 'password'; \
        ALTER ROLE hiveuser WITH CREATEDB; \
	CREATE ROLE ubuntu LOGIN PASSWORD 'ubuntu'; \
	ALTER ROLE ubuntu SUPERUSER;" \
    && sudo -u postgres psql -c "CREATE DATABASE metastore;" \
    && sudo -u postgres psql -c "CREATE DATABASE ubuntu" \
    && sudo -u postgres psql -d ubuntu -U ubuntu -c "SELECT 1 AS c" \
    && cd /usr/lib/hive/scripts/metastore/upgrade/postgres \
    && sudo -u postgres psql -d metastore -f hive-schema-1.1.0.postgres.sql \
    && sudo -u postgres psql -t -d metastore -f hive-grant-perms.sql | sudo -u postgres psql -d metastore

RUN rm /usr/lib/hive/scripts/metastore/upgrade/postgres/hive-grant-perms.sql

RUN locale-gen en_US en_US.UTF-8
RUN dpkg-reconfigure locales

RUN mkdir /var/run/hdfs-sockets/ ||:
RUN chown hdfs.hadoop /var/run/hdfs-sockets/

RUN mkdir -p /data/dn/
RUN chown hdfs.hadoop /data/dn

RUN service postgresql start \
    && sleep 10 \
    && psql -U hiveuser -d metastore -c 'SELECT * FROM "VERSION"' \
    && hive -e 'SHOW TABLES'

# Hadoop Configuration files
# /etc/hadoop/conf/ --> /etc/alternatives/hadoop-conf/ --> /etc/hadoop/conf/ --> /etc/hadoop/conf.empty/
# /etc/impala/conf/ --> /etc/impala/conf.dist
ADD files/core-site.xml /etc/hadoop/conf/
ADD files/hdfs-site.xml /etc/hadoop/conf/
ADD files/hive-site.xml /etc/hadoop/conf/
ADD files/core-site.xml /etc/impala/conf/
ADD files/hdfs-site.xml /etc/impala/conf/
ADD files/hive-site.xml /etc/impala/conf/
ADD files/hive-site.xml /etc/hive/conf.dist/

# Various helper scripts
ADD files/start-hdfs.sh /
ADD files/start-hive.sh /
ADD files/start-impala.sh /

RUN chmod +x /start-hdfs.sh
RUN chmod +x /start-hive.sh
RUN chmod +x /start-impala.sh

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENV SUDO_GROUP sudo

# setup the ubuntu user
RUN groupadd ubuntu
RUN groupadd supergroup

RUN useradd -u 1234 -g ubuntu -G sudo,supergroup -s /bin/bash ubuntu

RUN echo root:root | chpasswd
RUN echo ubuntu:ubuntu | chpasswd

RUN chown -R ubuntu /home/ubuntu
RUN chmod -R g-w /home/ubuntu
RUN chmod -R o-w /home/ubuntu

ENV BASH_COMPLETION /etc/bash_completion

USER ubuntu
WORKDIR /home/ubuntu
ENV USER ubuntu

# HDFS PORTS :
# 9000  Name Node IPC
# 50010 Data Node Transfer
# 50020 Data Node IPC
# 50070 Name Node HTTP
# 50075 Data Node HTTP


# IMPALA PORTS :
# 21000 Impala Shell
# 21050 Impala ODBC/JDBC
# 25000 Impala Daemon HTTP
# 25010 Impala State Store HTTP
# 25020 Impala Catalog HTTP

EXPOSE 9000 50010 50020 50070 50075 21000 21050 25000 25010 25020

ENTRYPOINT sudo service postgresql start && \
	   sudo /start-hive.sh

CMD ["sudo", "/start-impala.sh"]
