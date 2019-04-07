FROM debian:9.6-slim

LABEL maintainer="Joel Cumberland <mr.jrosco@gmail.com>"

# Setup env
ENV USER devbox

# Distro
#ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update

# Common packages
RUN apt-get install -q -y \
      sudo \
      wget \
      vim \
      python \
      python-dev \
      python-pip \
      python3-pip \
      python-virtualenv \
      openssh-server\
      git-core \
      jq \
      zsh \
      tmux \
      htop \
      pep8 \
      golang \
      python-sphinx \
      aptitude \
      locales \
      rubygems \
      ruby-dev \
      linkchecker \
      links \
      unzip \
      curl \
      yaml-mode \
      netcat \
      net-tools \
      bc \
      u-boot-tools \
      libncurses-dev \
      w3m \
    && apt-get clean -q -y

# Extra Packages (add below)
RUN apt-get install -q -y	\
      s3cmd \
      awscli

# Nodejs setup
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN sudo apt-get install nodejs && apt-get clean -q -y

# # Ruby gems / rvm
RUN gem install bundle
RUN sudo curl -sSL https://get.rvm.io | bash 
RUN set -ex \
      sh source /home/${USER}/.rvm/scripts/rvm

# Golang setup
ENV GO_VERSION go1.11.5
RUN wget https://dl.google.com/go/${GO_VERSION}.linux-amd64.tar.gz \
      && sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz \
      && rm ${GO_VERSION}.linux-amd64.tar.gz \
      && export PATH=$PATH:/usr/local/go/bin

# Locales
RUN sed -i 's/# \(en_US.UTF-8.*\)/\1/' /etc/locale.gen \
    && locale-gen en_US en_US.UTF-8

RUN adduser --quiet --disabled-password ${USER} --shell /bin/zsh \
      && mkdir -p /home/${USER}/.ssh/ \
      && mkdir -p /home/${USER}/.config/htop \
      && chown -R ${USER}:${USER} /home/${USER} \
      # && chmod 700 /home/${USER}/.ssh \
      # && chmod 600 /home/${USER}/.ssh/authorized_keys \
      && echo '%devbox   ALL= NOPASSWD: ALL' >> /etc/sudoers \
      && sudo -u ${USER} sh -c 'cd /home/${USER} ; wget http://install.ohmyz.sh -O - | sh || true'

# Confs and files
ADD confs/motd /etc/motd
ADD confs/gitconfig /home/devbox/.gitconfig
ADD confs/zsh /home/devbox/.zshrc
ADD confs/htoprc /home/devbox/.config/htop/htoprc
RUN chown ${USER}:${USER} /home/${USER}/.gitconfig /home/${USER}/.zshrc

ADD bin/init /init-container

EXPOSE 22 2000

ENTRYPOINT ["/init-container"]
