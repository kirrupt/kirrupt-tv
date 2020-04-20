FROM elixir:1.5-slim

ENV LANG=C.UTF-8

# nodejs prereq
RUN apt-get update \
	&& apt-get install -y curl && \
	curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
	apt-get install -y --no-install-recommends ca-certificates git build-essential nodejs npm && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

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
