FROM centos:centos7

ADD ./ /

RUN chmod 777 /efo_load.sh
RUN yum -y install epel-release
RUN yum -y install curl && yum -y install wget && yum -y install jq
RUN mkdir /work && mkdir /data

ENTRYPOINT [ "/efo_load.sh" ]


