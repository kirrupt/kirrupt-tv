FROM debian:buster

ENV ELIXIR_VERSION="v1.5.2" \
	LANG=C.UTF-8

# nodejs prereq
RUN apt-get update \
	&& apt-get install -y curl \
	&& apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_13.x | bash -

# install nodejs, imagemagick, build-essentials
RUN apt-get install -y wget curl gnupg unzip git build-essential imagemagick \
					   gdebi-core nodejs procps \
	&& apt-get clean

# install erlang
RUN curl -fSL -o erlang.deb https://packages.erlang-solutions.com/erlang/debian/pool/esl-erlang_20.3.8.25-1~debian~buster_amd64.deb \
	&& echo "6dd4efc6ccc7bed6fa9d154de0f17a6f69ed40472292a3ca246c1b6ebf91f630  erlang.deb" | sha256sum -c - \
	&& gdebi --non-interactive ./erlang.deb \
	&& rm erlang.deb \
	&& apt-get clean

# install elixir
RUN set -xe \
	&& ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/releases/download/${ELIXIR_VERSION}/Precompiled.zip" \
	&& ELIXIR_DOWNLOAD_SHA256="4ba8dd46998bee6cbcc2d9937776e241be82bc62d2b62b6235c310a44c87467e"\
	&& curl -fSL -o elixir-precompiled.zip $ELIXIR_DOWNLOAD_URL \
	&& echo "$ELIXIR_DOWNLOAD_SHA256  elixir-precompiled.zip" | sha256sum -c - \
	&& unzip -d /usr/local elixir-precompiled.zip \
	&& rm elixir-precompiled.zip

ADD mix.exs /app/mix.exs
ADD mix.lock /app/mix.lock

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

ADD package.json /app/package.json

RUN npm install

ENV MIX_ENV dev
RUN mix compile

ADD . /app

RUN ./node_modules/brunch/bin/brunch build --production
RUN mix phx.digest

RUN mix compile
