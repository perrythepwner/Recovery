FROM ubuntu:latest

RUN apt-get update -y && \
    apt-get install -y \
    zsh \
    git \
    sudo \
    curl \
    openssh-server

ARG SSH_PORT
ARG SSH_USER
ARG SSH_PWD

RUN useradd -m ${SSH_USER}
RUN echo ${SSH_USER}:${SSH_PWD} | chpasswd

USER ${SSH_USER}
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ENV ZSH=/home/${SSH_USER}/.oh-my-zsh
RUN sed -i -e "/source \$ZSH\/oh-my-zsh.sh/i export ZSH_COMPDUMP=\$ZSH\/cache\/.zcompdump-\$HOST" /home/${SSH_USER}/.zshrc
RUN rm -rf /home/${SSH_USER}/.zcompdump
RUN echo 'PROMPT="%{$fg[yellow]%}%n@%{$fg[green]%}%m%{$reset_color%} ${PROMPT}"' >> $ZSH/themes/robbyrussell.zsh-theme

USER root
RUN chsh -s $(which zsh) ${SSH_USER}

RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

RUN chown -R ${SSH_USER}:${SSH_USER} /home/${SSH_USER}

EXPOSE ${SSH_PORT}

CMD ["/usr/sbin/sshd", "-D"]