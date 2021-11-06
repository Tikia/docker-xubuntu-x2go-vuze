FROM ubuntu:22.04
MAINTAINER Tikia "renaud@tikia.net"

# Update OS
RUN apt-get update
RUN apt-get -y upgrade

#Define ENV
ENV DEBIAN_FRONTEND noninteractive

#Install ssh-server, xubuntu, java and others dependencies
RUN apt-get install -y openssh-server xubuntu-desktop openjdk-8-jre wget vim-nox

#Install x2go
RUN add-apt-repository ppa:x2go/stable
RUN apt-get update
RUN apt-get install -y x2goserver x2goserver-xsession pwgen

#Config OS
RUN mkdir -p /var/run/sshd && sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config
RUN sed -i "s/PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config
RUN sed -i "s/#PasswordAuthentication/PasswordAuthentication/g" /etc/ssh/sshd_config
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

#Install Vuze
RUN echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb apps" | tee /etc/apt/sources.list.d/getdeb.list &&  wget -q http://archive.getdeb.net/getdeb-archive.key -O- | apt-key add -
RUN apt-get update
RUN apt-get install -y vuze

#Add password script
ADD https://raw.githubusercontent.com/Tikia/docker-xubuntu-x2go-vuze/master/root_pw_set.sh /
ADD https://raw.githubusercontent.com/Tikia/docker-xubuntu-x2go-vuze/master/run.sh /
RUN chmod +x /*.sh

#Define port
EXPOSE 22

#Define Volume
VOLUME ["/home/dockerx/Downloads/Vuze", "/home/dockerx/Downloads/Torrents"]

#Define CMD
CMD ["/run.sh"]
