FROM debian:stretch

ENV ELIXIR_VERSION="v1.5.2" \
	LANG=C.UTF-8

RUN apt-get update && \
    apt-get install -y wget curl gnupg unzip git build-essential imagemagick

# install erlang
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
    dpkg -i erlang-solutions_1.0_all.deb && \
    apt-get update && \
    apt-get install -y esl-erlang

# install elixir
RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip" \
	&& ELIXIR_DOWNLOAD_SHA256="4ba8dd46998bee6cbcc2d9937776e241be82bc62d2b62b6235c310a44c87467e"\
	&& curl -fSL -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-precompiled.zip" | sha256sum -c - \
	&& unzip -d /usr/local elixir-precompiled.zip \
	&& rm elixir-precompiled.zip

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
	apt-get install -y nodejs

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ADD . /app

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

RUN npm install

ENV MIX_ENV prod
RUN mix compile
RUN ./node_modules/brunch/bin/brunch build --production
RUN mix phoenix.digest
