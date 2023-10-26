FROM ubuntu:latest

RUN apt-get update -y && \
    apt-get install -y \
    openssh-server \
    sudo

ARG SSH_PORT
ARG SSH_USER
ARG SSH_PWD
ENV TERM xterm-256color

RUN useradd -m ${SSH_USER}
RUN echo ${SSH_USER}:${SSH_PWD} | chpasswd

RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

EXPOSE ${SSH_PORT}

CMD ["/usr/sbin/sshd", "-D"]