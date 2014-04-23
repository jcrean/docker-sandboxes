FROM dockerfile/java

RUN apt-get update && apt-get install -y openssh-server

RUN mkdir /var/run/sshd

ADD files/id_rsa.hadoop /root/.ssh/id_rsa
ADD files/id_rsa.hadoop.pub /root/.ssh/id_rsa.pub
ADD files/id_rsa.hadoop.pub /root/.ssh/authorized_keys

CMD /usr/sbin/sshd

RUN wget http://mirror.tcpdiag.net/apache/hadoop/common/hadoop-2.4.0/hadoop-2.4.0.tar.gz
RUN tar xzf hadoop-2.4.0.tar.gz -C /usr/local
RUN ln -s /usr/local/hadoop-2.4.0 /usr/local/hadoop

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
ENV HADOOP_PREFIX /usr/local/hadoop
