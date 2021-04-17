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

# Compile deps for `prod`
ENV MIX_ENV prod
RUN mix deps.compile

# Compile deps for `test`
ENV MIX_ENV test
RUN mix deps.compile

# Use `prod`
ENV MIX_ENV prod

ADD package.json /app/package.json

RUN npm install

WORKDIR /app

ADD . /app

RUN ./node_modules/brunch/bin/brunch build --production
RUN mix phx.digest

RUN mix compile

CMD mix phx.server --no-compile
