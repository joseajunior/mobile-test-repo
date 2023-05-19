# Dockerfile using yum Instant Client RPMs
FROM oraclelinux:7-slim
RUN yum -y install oracle-release-el7 && \
    yum -y install oracle-instantclient-release-el7 && \
    yum -y install python 3 \
                   python3-libs \
                   python3-pip \
                   python3-setuptools \
                   python37-cx_Oracle && \
    rm -rf /var/cache/yum

FROM ghcr.io/joseajunior/basecontainer:latest

# Install OTR Robot Library
RUN pip install --extra-index-url https://us-east-1.artifactory.wexapps.com/artifactory/api/pypi/EFSROBOT/simple --trusted-host pypi.org --trusted-host https://us-east-1.artifactory.wexapps.com --no-cache-dir otr_robot_lib
RUN pip install robotframework-pabot
RUN pip install cx_Oracle

# Set up Oracle Driver Environment variables
ARG oracle_client_version=instantclient_19_6
ENV LD_LIBRARY_PATH /oracle_cli
RUN mkdir $LD_LIBRARY_PATH

# Download and Install oracle Client
RUN wget --no-check-certificate -q --continue -P $LD_LIBRARY_PATH https://download.oracle.com/otn_software/linux/instantclient/216000/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip && \
    mkdir -p /opt/oracle/intantclient_21_6/ && \
    cd /opt/oracle/ && \
    apt-get install libaio1 && \
    unzip $LD_LIBRARY_PATH/instantclient-basic-linux.x64-21.6.0.0.0dbru.zip && \
    cd instantclient_21_6/
# RUN ln -s libclntsh.so.21.1 libclntsh.so && \
#     ln -s libocci.so.21.1 libocci.so && \
ENV ORACLE_HOME=/opt/oracle/instantclient_21_6
ENV LD_LIBRARY_PATH=$ORACLE_HOME:$LD_LIBRARY_PATH
ENV PATH=$ORACLE_HOME:$PATH
ENV PATH=/oracle/instantclient_21_6:$PATH
#RUN apt-get install libaio1 

#RUN apt-get install libaio
RUN sh -c "echo /opt/oracle/instantclient_21_6 > /etc/ld.so.conf.d/oracle-instantclient.conf"
RUN ldconfig

# Adding current project
ADD . /frontend_robot