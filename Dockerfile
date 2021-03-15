FROM alpine:3.13

RUN apk add --no-cache elixir  nodejs nodejs-npm git make g++ ca-certificates && \
    update-ca-certificates --fresh && \
    rm -rf /var/cache/apk/*

ADD mix.exs /app/mix.exs
ADD mix.lock /app/mix.lock

WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get

ADD package.json /app/package.json

RUN npm install

WORKDIR /app/frontend
ADD frontend/package* /app/frontend/
RUN npm install

ADD frontend/ /app/frontend/
RUN npm run build

WORKDIR /app

ENV MIX_ENV prod
RUN mix compile

ADD . /app

RUN ./node_modules/brunch/bin/brunch build --production
RUN mix phx.digest

RUN mix compile

CMD mix phx.server --no-compile
