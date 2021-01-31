FROM ubuntu:20.10 as dotfiles-base

#---------- system setup

RUN apt-get -y update
RUN apt-get -y install sudo

# XXX: need to expliiclty install tzdata non-interactively or else
# it hangs on user input in aptitude.sh script
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y install tzdata

# install apt packages first to cache this layer as it takes a long time
COPY etc/aptitude.sh /app/aptitude.sh
RUN /app/aptitude.sh

ENV HOME=/root
WORKDIR $HOME

#---------- general env setup

# add only dotfiles and setup_env script to optimize docker caching
RUN mkdir -p $HOME/.dotfiles/etc
ADD .* $HOME/.dotfiles/
ADD etc/setup_env.sh $HOME/.dotfiles/etc

# can't use the $HOME/etc symlink yet as this script creates it
RUN bash -i -c "$HOME/.dotfiles/etc/setup_env.sh"

#---------- tools image layer

FROM dotfiles-base as dotfiles-tools

ADD etc/* $HOME/.dotfiles/etc

# TODO: consolidate all the calls below into one setup_all.sh script
RUN bash -i -c "$HOME/etc/python_tools_install.sh"
RUN bash -i -c "$HOME/etc/js_tools.sh"
RUN bash -i -c "$HOME/etc/rust.sh"
RUN bash -i -c "$HOME/etc/ruby.sh"

ENTRYPOINT /bin/zsh
