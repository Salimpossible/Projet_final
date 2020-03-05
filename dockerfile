FROM centos:centos8
RUN yum -y update && yum -y install git && yum -y install unzip
RUN curl -s -LO https://releases.hashicorp.com/terraform/0.12.21/terraform_0.12.21_linux_amd64.zip
RUN unzip terraform_0.12.21_linux_amd64.zip
RUN mv terraform /usr/bin
