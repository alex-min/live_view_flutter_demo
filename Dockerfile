# Production mode Dockerfile
# This Dockerfile is also using the .tool-versions file and asdf
FROM ubuntu:latest
RUN ls
# Packages for asdf & erlang build
RUN apt-get update -q && apt install -y libssl-dev zlib1g-dev automake autoconf curl git unzip gcc libncurses5-dev libncursesw5-dev build-essential && adduser --gecos "" --shell /bin/bash --home /asdf --disabled-password asdf
ENV PATH="${PATH}:/asdf/.asdf/shims:/asdf/.asdf/bin"

# Creating the main directory
RUN mkdir /www
RUN chown asdf:asdf /www
WORKDIR /www

# install asdf
USER asdf
RUN git clone --depth 1 https://github.com/asdf-vm/asdf.git $HOME/.asdf && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.bashrc && \
    echo '. $HOME/.asdf/asdf.sh' >> $HOME/.profile

# asdf plugins 
RUN asdf plugin-add erlang https://github.com/alex-min/asdf-erlang-prebuilt-ubuntu && asdf plugin-add elixir && asdf plugin-add nodejs && asdf plugin-add yarn
COPY .tool-versions /www

# install only the plugins that are needed in production
RUN asdf install erlang && asdf install elixir

RUN mix local.rebar --force && mix local.hex --force

ENV MIX_ENV=prod

# definition and lock files for packages
COPY --chown=asdf:asdf mix.exs mix.lock /www/
# needed for mix
ENV LANG=C.UTF-8

RUN mix deps.get --only $MIX_ENV

# compile
RUN mkdir config
COPY config/config.exs config/${MIX_ENV}.exs config/native.exs config/
RUN mix deps.compile

# copy all the project
COPY --chown=asdf:asdf . /www 
COPY --chown=asdf:asdf priv/docker-entrypoint.sh /www/docker-entrypoint.sh 
RUN chmod a+x docker-entrypoint.sh 

# Building assets
ENV NODE_ENV=production
RUN env SKIP_LOADING_PROD_SECRETS=true mix assets.deploy

# we skip loading the prod secrets for the phx.digest & compile since they are not available yet
RUN env SKIP_LOADING_PROD_SECRETS=true mix phx.digest
RUN env SKIP_LOADING_PROD_SECRETS=true mix compile
CMD /www/docker-entrypoint.sh